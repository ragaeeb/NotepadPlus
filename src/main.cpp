#include "precompiled.h"

#include "NotepadPlus.h"
#include "Logger.h"

using namespace bb::cascades;
using namespace notepad;

#ifdef DEBUG
namespace {

void redirectedMessageOutput(QtMsgType type, const char *msg) {
	Q_UNUSED(type);
	fprintf(stderr, "%s\n", msg);
}

}
#endif

Q_DECL_EXPORT int main(int argc, char **argv)
{
	QByteArray value = QSettings().value("theme").toString().toLocal8Bit();
	const char* xyz = value.isNull() ? NotepadPlus::default_theme : value.data();
	setenv("CASCADES_THEME", value.isNull() ? NotepadPlus::default_theme : value.data(), 1);

    Application app(argc, argv);

#ifdef DEBUG
	qInstallMsgHandler(redirectedMessageOutput);
#endif

    NotepadPlus::create(&app);

    return Application::exec();
}
