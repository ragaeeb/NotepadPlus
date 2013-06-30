#ifndef NOTEPADPLUS_H_
#define NOTEPADPLUS_H_

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

    NotepadPlus(Application* app);

public:
    static void create(Application* app);
    virtual ~NotepadPlus() {}
    Q_INVOKABLE bool save(QString const& fileName, QString contents);
};

} // notepad

#endif /* NOTEPADPLUS_H_ */
