#ifndef FILEREADERTHREAD_H_
#define FILEREADERTHREAD_H_

#include <QObject>
#include <QRunnable>
#include <QVariant>

namespace canadainc {

class FileReaderThread : public QObject, public QRunnable
{
	Q_OBJECT

	QString m_path;
	bool m_binary;

	void readBinary();
	void readText();

signals:
	void fileLoaded(QString const& path, QVariant const& data);
	void progress(qint64 current, qint64 total);

public:
	FileReaderThread(QObject* parent=NULL);
	virtual ~FileReaderThread();
	void setPath(QString const& path);
	void setBinaryMode(bool binary=true);

	QString path() const;
	void run();
};

} /* namespace canadainc */
#endif /* FILEREADERTHREAD_H_ */
