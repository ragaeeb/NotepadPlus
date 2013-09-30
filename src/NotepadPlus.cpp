#include "precompiled.h"

#include "NotepadPlus.h"
#include "InvocationUtils.h"
#include "IOUtils.h"
#include "Logger.h"

namespace notepad {

using namespace bb::cascades;
using namespace canadainc;

NotepadPlus::NotepadPlus(bb::cascades::Application *app) : QObject(app)
{
	INIT_SETTING("theme", "bright");
	INIT_SETTING("loadCache", 1);

	connect( &m_invokeManager, SIGNAL( invoked(bb::system::InvokeRequest const&) ), this, SLOT( invoked(bb::system::InvokeRequest const&) ) );

	switch ( m_invokeManager.startupMode() )
	{
	case ApplicationStartupMode::LaunchApplication:
		loadRoot("main.qml");
		break;

	default:
		connect( &m_invokeManager, SIGNAL( invoked(bb::system::InvokeRequest const&) ), this, SLOT( invoked(bb::system::InvokeRequest const&) ) );
		break;
	}
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

	QObject* root = loadRoot("main.qml", true);
	QString body = IOUtils::readTextFile(uri);

	root->setProperty("lastSavedFile", uri);
	root->setProperty("body", body);
}


void NotepadPlus::init() {
    InvocationUtils::validateSharedFolderAccess( tr("Warning: It seems like the app does not have access to your Shared Folder. This permission is needed for the app to access the file system so that it can allow you to save your files and open them. If you leave this permission off, some features may not work properly.") );
}


bool NotepadPlus::save(QString const& fileName, QString contents)
{
	LOGGER("Save" << fileName);
	return IOUtils::writeTextFile(fileName, contents);
}


bool NotepadPlus::changeTheme(QString const& theme)
{
	QString body = IOUtils::readTextFile("app/META-INF/MANIFEST.MF");

	if ( body.isNull() ) {
		return false;
	}

	if (theme == "dark") {
		body = body.replace("CASCADES_THEME=bright","CASCADES_THEME=dark");
		QFile::rename("app/native/splash_n.png", "app/native/splash_n_bright.png");
		QFile::rename("app/native/splash_n_dark.png", "app/native/splash_n.png");
	} else if (theme == "bright") {
		body = body.replace("CASCADES_THEME=dark","CASCADES_THEME=bright");
		QFile::rename("app/native/splash_n.png", "app/native/splash_n_dark.png");
		QFile::rename("app/native/splash_n_bright.png", "app/native/splash_n.png");
	}

	IOUtils::writeTextFile("app/META-INF/MANIFEST.MF", body, true, false);

	return true;
}


void NotepadPlus::create(bb::cascades::Application* app) {
	new NotepadPlus(app);
}


} // notepad
