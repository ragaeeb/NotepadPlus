#include "precompiled.h"

#include "NotepadPlus.h"
#include "FileReaderThread.h"
#include "InvocationUtils.h"
#include "IOUtils.h"
#include "Logger.h"

namespace {

QString loadLastSaved()
{
    QSettings s;
    return s.value("data").toString();
}

}

namespace notepad {

using namespace bb::cascades;
using namespace bb::system;
using namespace canadainc;

NotepadPlus::NotepadPlus(bb::cascades::Application *app) : QObject(app)
{
	INIT_SETTING("loadCache", 1);

	loadRoot("main.qml");

	LOGGER( "Constructor" << m_invokeManager.startupMode() );

	switch ( m_invokeManager.startupMode() )
	{
	case ApplicationStartupMode::InvokeApplication:
	case ApplicationStartupMode::InvokeCard:
		LOGGER("INVOKED!!");
		connect( &m_invokeManager, SIGNAL( invoked(bb::system::InvokeRequest const&) ), this, SLOT( invoked(bb::system::InvokeRequest const&) ) );
		break;

	default:
		if ( m_persistance.getValueFor("loadCache") == 1 )
		{
		    connect( &m_future, SIGNAL( finished() ), this, SLOT( onLoadComplete() ) );

		    QFuture<QString> future = QtConcurrent::run(loadLastSaved);
		    m_future.setFuture(future);

			m_activity.setTitle( tr("Loading...") );
			m_activity.setBody( tr("Loading cache...") );
			m_activity.show();
		}

		break;
	}
}


void NotepadPlus::onLoadComplete()
{
    QObject* root = Application::instance()->scene();
    root->setProperty( "lastSavedFile", m_persistance.getValueFor("lastFile") );
    root->setProperty( "body", m_future.result() );

    m_activity.cancel();
}


QObject* NotepadPlus::loadRoot(QString const& qmlDoc, bool invoked)
{
	Q_UNUSED(invoked);

	qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("bb.cascades.pickers", 1, 0, "FilePickerMode", "Can't instantiate");
	qmlRegisterType<bb::UIToolkitSupport>("bb", 1, 0, "UIToolkitSupport");

    QmlDocument* qml = QmlDocument::create( QString("asset:///%1").arg(qmlDoc) ).parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);

    AbstractPane* root = qml->createRootObject<AbstractPane>();

	connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup
	emit initialize();

    Application::instance()->setScene(root);

    return root;
}


void NotepadPlus::invoked(bb::system::InvokeRequest const& request)
{
	QString uri = request.uri().toLocalFile();
	LOGGER("========= INVOKED WITH" << uri );

	open(QStringList() << uri);
}


void NotepadPlus::open(QStringList const& uris)
{
	m_progress.setState(SystemUiProgressState::Active);
	m_progress.setStatusMessage( tr("0% complete...") );
	m_progress.setProgress(0);
	m_progress.show();

	for (int i = uris.size()-1; i >= 0; i--)
	{
	    FileReaderThread* frt = new FileReaderThread();
	    frt->setPath( uris[i] );
	    connect( frt, SIGNAL( fileLoaded(QString const&, QVariant const&) ), this, SLOT( onFileLoaded(QString const&, QVariant const&) ) );
	    connect( frt, SIGNAL( progress(qint64, qint64) ), this, SLOT( onProgress(qint64, qint64) ) );

	    IOUtils::startThread(frt);
	}
}


void NotepadPlus::onProgress(qint64 current, qint64 total)
{
	int progress = (double)current/total * 100;
	m_progress.setProgress(progress);
	m_progress.setStatusMessage( tr("%1% complete...").arg(progress) );
	m_progress.show();
}


void NotepadPlus::onFileLoaded(QString const& path, QVariant const& data)
{
	QString body = data.toString();
	LOGGER("Setting invoke data" << path << body);

	QObject* root = Application::instance()->scene();
	root->setProperty("lastSavedFile", path);
	root->setProperty("body", body);

	m_progress.cancel();
	m_progress.setState(SystemUiProgressState::Inactive);
}


void NotepadPlus::init()
{
	INIT_SETTING("theme", default_theme);
	INIT_SETTING("input", "/accounts/1000/removable/sdcard/documents");

	m_progress.setState(SystemUiProgressState::Inactive);
	m_progress.setAutoUpdateEnabled(true);
/*
    bool ok = InvocationUtils::validateSharedFolderAccess( tr("Warning: It seems like the app does not have access to your Shared Folder. This permission is needed for the app to access the file system so that it can allow you to save your files and open them. If you leave this permission off, some features may not work properly.") );

    if (ok) {
    	if ( !m_persistance.contains("swipeTutorial") ) {
        	m_persistance.showToast( tr("To show the menu-bar at the bottom, either tap or swipe-down from the top-bezel."), tr("OK") );
        	m_persistance.saveValueFor("swipeTutorial", 1);
    	}
    } */
}


void NotepadPlus::share(QString const& fileName, QString const& targetId)
{
    LOGGER(fileName << targetId);

    InvokeRequest request;
    request.setUri( QUrl::fromLocalFile(fileName) );
    request.setTarget(targetId);
    request.setAction("bb.action.SHARE");

    InvokeManager().invoke(request);
}


void NotepadPlus::shareLocal(QString const& text, QString const& targetId)
{
    LOGGER(text << targetId);

    QString fileName = QString("%1/untitled.txt").arg( QDir::tempPath() );

    bool written = IOUtils::writeTextFile(fileName, text, true);
    LOGGER(written);

    if (written) {
        share(fileName, targetId);
    }
}


bool NotepadPlus::save(QString const& fileName, QString contents)
{
	LOGGER("Save" << fileName);
	return IOUtils::writeTextFile(fileName, contents);
}


void NotepadPlus::create(bb::cascades::Application* app) {
	new NotepadPlus(app);
}


} // notepad
