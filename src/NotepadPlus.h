#ifndef NOTEPADPLUS_H_
#define NOTEPADPLUS_H_

#include <QSettings>

namespace bb {
	namespace cascades {
		class Application;
		class AbstractTextControl;
	}
}

namespace notepad {

using namespace bb::cascades;

class NotepadPlus : public QObject
{
    Q_OBJECT

    AbstractTextControl* m_textArea;
    QSettings m_settings;

    NotepadPlus(Application* app);

private slots:
	void onAboutToQuit();

public:
    static void create(Application* app);
    virtual ~NotepadPlus() {}
};

} // notepad

#endif /* NOTEPADPLUS_H_ */
