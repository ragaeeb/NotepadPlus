#include "precompiled.h"

#include "NotepadPlus.h"
#include "InvocationUtils.h"
#include "IOUtils.h"
#include "Logger.h"

namespace notepad {

using namespace bb::cascades;
using namespace canadainc;

const char* NotepadPlus::default_theme = "bright";

NotepadPlus::NotepadPlus(bb::cascades::Application *app) : QObject(app)
{
	INIT_SETTING("theme", default_theme);
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

	open(uri);
}


void NotepadPlus::open(QString const& uri)
{
	QObject* root = Application::instance()->scene();
	QString body = IOUtils::readTextFile(uri);

	LOGGER("Setting invoke data" << uri << body);

	root->setProperty("lastSavedFile", uri);
	root->setProperty("body", body);
}


void NotepadPlus::init()
{
	INIT_SETTING("input", "/accounts/1000/removable/sdcard/documents");
    InvocationUtils::validateSharedFolderAccess( tr("Warning: It seems like the app does not have access to your Shared Folder. This permission is needed for the app to access the file system so that it can allow you to save your files and open them. If you leave this permission off, some features may not work properly.") );
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
