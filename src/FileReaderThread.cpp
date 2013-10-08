#include "precompiled.h"

#include "FileReaderThread.h"
#include "IOUtils.h"
#include "Logger.h"

namespace canadainc {

FileReaderThread::FileReaderThread(QObject* parent) : QObject(parent), m_binary(false)
{
}


void FileReaderThread::setPath(QString const& path) {
	m_path = path;
}


void FileReaderThread::run()
{
	if ( !m_path.isNull() )
	{
		if (m_binary) {
			readBinary();
		} else {
			readText();
		}
	}
}


void FileReaderThread::readBinary()
{
	LOGGER("Not yet implemented!");
}


void FileReaderThread::readText()
{
	LOGGER("Reading text");
	QFile outputFile(m_path);
	bool opened = outputFile.open(QIODevice::ReadOnly);
	QString result;

	if (opened) {
		int total = outputFile.size();
		const int chunkSize = total*0.1;
		QTextStream stream(&outputFile);

		while ( !stream.atEnd() ) {
			result += stream.read(chunkSize);
			emit progress( stream.pos(), total );
		}

		emit progress(total, total);
	} else {
		LOGGER("Could not open " << m_path << "for writing!");
	}

	emit fileLoaded(m_path, result);
}


QString FileReaderThread::path() const {
	return m_path;
}


void FileReaderThread::setBinaryMode(bool binary) {
	m_binary = binary;
}


FileReaderThread::~FileReaderThread()
{
}

} /* namespace canadainc */
