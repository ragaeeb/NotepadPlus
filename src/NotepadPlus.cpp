#include "NotepadPlus.h"
#include "Logger.h"

#include <bb/cascades/AbstractPane>
#include <bb/cascades/AbstractTextControl>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>

namespace notepad {

using namespace bb::cascades;

NotepadPlus::NotepadPlus(bb::cascades::Application *app) : QObject(app)
{
	connect( app, SIGNAL( aboutToQuit() ), this, SLOT( onAboutToQuit() ) );

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    AbstractPane* root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

    m_textArea = root->findChild<AbstractTextControl*>("textArea");

    QString data = m_settings.value("data").toString();

    LOGGER("Fetched" << data);

    m_textArea->setText(data);
}


void NotepadPlus::create(bb::cascades::Application *app) {
	new NotepadPlus(app);
}


void NotepadPlus::onAboutToQuit()
{
	QString toSave = m_textArea->text();

	LOGGER("Saving: " << toSave);

	m_settings.setValue("data", toSave);
}


} // notepad
