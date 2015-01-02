#include "precompiled.h"

#include "NotepadPlus.h"

using namespace bb::cascades;
using namespace notepad;

Q_DECL_EXPORT int main(int argc, char **argv)
{
	QByteArray value = QSettings().value("theme").toString().toLocal8Bit();
	setenv("CASCADES_THEME", value.isNull() ? default_theme : value.data(), 1);

    Application app(argc, argv);
    NotepadPlus::create(&app);

    return Application::exec();
}
