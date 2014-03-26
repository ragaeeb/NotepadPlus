#ifndef ASYNCSETTINGLOADER_H_
#define ASYNCSETTINGLOADER_H_

#include <QObject>
#include <QRunnable>
#include <QStringList>

namespace canadainc {

class Persistance;

class AsyncSettingLoader : public QObject, public QRunnable
{
	Q_OBJECT

	Persistance* m_persistance;
	QStringList m_keys;

signals:
	void settingLoaded(QString const& key, QVariant const& result);

public:
	AsyncSettingLoader(Persistance* persistance, QStringList const& keys);
	virtual ~AsyncSettingLoader();

	void run();
};

} /* namespace canadainc */
#endif /* ASYNCSETTINGLOADER_H_ */
