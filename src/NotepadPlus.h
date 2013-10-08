#ifndef NOTEPADPLUS_H_
#define NOTEPADPLUS_H_

#include <bb/system/InvokeManager>
#include <bb/system/SystemProgressToast>

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
    bb::system::SystemProgressToast m_progress;

    NotepadPlus(Application* app);
    QObject* loadRoot(QString const& qml, bool invoked=false);

private slots:
	void init();
	void invoked(bb::system::InvokeRequest const& request);
	void onProgress(qint64 current, qint64 total);
	void onSettingLoaded(QString const& key, QVariant const& result);
	void onFileLoaded(QString const& path, QVariant const& data);

signals:
	void initialize();

public:
	static const char* default_theme;
    static void create(Application* app);
    virtual ~NotepadPlus() {}
    Q_INVOKABLE void open(QString const& fileName);
    Q_INVOKABLE bool save(QString const& fileName, QString contents);
};

} // notepad

#endif /* NOTEPADPLUS_H_ */
