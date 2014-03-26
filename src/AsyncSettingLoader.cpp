#include "AsyncSettingLoader.h"
#include "Persistance.h"

namespace canadainc {

AsyncSettingLoader::AsyncSettingLoader(Persistance* persistance, QStringList const& keys) : m_persistance(persistance), m_keys(keys)
{
}


void AsyncSettingLoader::run()
{
	for (int i = m_keys.size()-1; i >= 0; i--)
	{
		QString key = m_keys[i];
		QVariant result = m_persistance->getValueFor(key);
		emit settingLoaded(key, result);
	}
}


AsyncSettingLoader::~AsyncSettingLoader()
{
}

} /* namespace canadainc */
