#ifndef NOTEPADPLUS_H_
#define NOTEPADPLUS_H_

#include <bb/system/InvokeManager>

#include "Persistance.h"

namespace bb {
	namespace cascades {
		class Application;
	}
}

namespace notepad {

using namespace bb::cascades;
using namespace canadainc;

class NotepadPlus : public QObject
{
    Q_OBJECT

    Persistance m_persistance;
    bb::system::InvokeManager m_invokeManager;

    NotepadPlus(Application* app);
    QObject* loadRoot(QString const& qml, bool invoked=false);

private slots:
	void init();
	void invoked(bb::system::InvokeRequest const& request);

signals:
	void initialize();

public:
    static void create(Application* app);
    virtual ~NotepadPlus() {}
    Q_INVOKABLE bool save(QString const& fileName, QString contents);
    Q_INVOKABLE bool changeTheme(QString const& theme);
};

} // notepad

#endif /* NOTEPADPLUS_H_ */
