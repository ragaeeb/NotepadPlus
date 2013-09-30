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
	qmlRegisterType<bb::cascades::pickers::FilePicker>("bb.cascades.pickers", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("bb.cascades.pickers", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("bb.cascades.pickers", 1, 0, "FilePickerMode", "Can't instantiate");
	qmlRegisterType<bb::UIToolkitSupport>("bb", 1, 0, "UIToolkitSupport");

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);

    AbstractPane* root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

	connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup
	emit initialize();
}


void NotepadPlus::init()
{
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
