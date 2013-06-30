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
#ifdef DEBUG
	qInstallMsgHandler(redirectedMessageOutput);
#endif

    Application app(argc, argv);
    NotepadPlus::create(&app);

    return Application::exec();
}
