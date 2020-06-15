#include "mainwindow.h"

#if defined(Q_OS_MACOS)
  #include <mach-o/dyld.h>
#endif

#include <QApplication>
#include <vector>
#include "client/crash_report_database.h"
#include "client/crashpad_client.h"
#include "client/settings.h"

using namespace base;
using namespace crashpad;
using namespace std;

bool initializeCrashpad(QString dbName, QString appName, QString appVersion);
QString getExecutableDir(void);

int main(int argc, char *argv[])
{
    QString dbName = "Fred";
    QString appName = "myQtCrasher";
    QString appVersion = "1.0";

    initializeCrashpad(dbName, appName, appVersion);

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}

bool initializeCrashpad(QString dbName, QString appName, QString appVersion)
{
    // Get directory where the exe lives so we can pass a full path to handler, reportsDir and metricsDir
    QString exeDir = getExecutableDir();

    // Ensure that handler is shipped with your application
    QString handlerPath = exeDir + "/../../../crashpad/crashpad_handler";
    FilePath handler(handlerPath.toStdWString()); // TODO BG fix for mac

    // Directory where reports will be saved. Important! Must be writable or crashpad_handler will crash.
    QString reportsPath = exeDir + "/../../../crashpad";
    FilePath reportsDir(reportsPath.toStdWString()); // TODO BG fix for mac

    // Directory where metrics will be saved. Important! Must be writable or crashpad_handler will crash.
    QString metricsPath = exeDir + "/../../../crashpad";
    FilePath metricsDir(metricsPath.toStdWString());

    // Configure url with your BugSplat database
    QString url = "https://" + dbName + ".bugsplat.com/post/bp/crash/crashpad.php";

    // Metadata that will be posted to BugSplat
    QMap<string, string> annotations;
    annotations["format"] = "minidump";                 // Required: Crashpad setting to save crash as a minidump
    annotations["database"] = dbName.toStdString();     // Required: BugSplat database
    annotations["product"] = appName.toStdString();     // Required: BugSplat appName
    annotations["version"] = appVersion.toStdString();  // Required: BugSplat appVersion
    annotations["key"] = "Sample key";                  // Optional: BugSplat key field
    annotations["user"] = "fred@bugsplat.com";          // Optional: BugSplat user email
    annotations["list_annotations"] = "Sample comment";	// Optional: BugSplat crash description

    // Disable crashpad rate limiting so that all crashes have dmp files
    vector<string> arguments;
    arguments.push_back("--no-rate-limit");

    // Initialize crashpad database
    unique_ptr<CrashReportDatabase> database = CrashReportDatabase::Initialize(reportsDir);
    if (database == NULL) return false;

    // Enable automated crash uploads
    Settings *settings = database->GetSettings();
    if (settings == NULL) return false;
    settings->SetUploadsEnabled(true);

    // Start crash handler
    CrashpadClient *client = new CrashpadClient();
    bool status = client->StartHandler(handler, reportsDir, metricsDir, url.toStdString(), annotations.toStdMap(), arguments, true, true);
    return status;
}

QString getExecutableDir() {
#if defined(Q_OS_MACOS)
    unsigned int bufferSize = 512;
    vector<char> buffer(bufferSize + 1);

    if(_NSGetExecutablePath(&buffer[0], &bufferSize))
    {
        buffer.resize(bufferSize);
        _NSGetExecutablePath(&buffer[0], &bufferSize);
    }

    char* lastForwardSlash = strrchr(&buffer[0], '/');
    if (lastForwardSlash == NULL) return NULL;
    *lastForwardSlash = 0;

    return &buffer[0];
#elif defined(Q_OS_WINDOWS)
    HMODULE hModule = GetModuleHandleW(NULL);
    WCHAR path[MAX_PATH];
    DWORD retVal = GetModuleFileNameW(hModule, path, MAX_PATH);
    if (retVal == 0) return NULL;

    wchar_t *lastBackslash = wcsrchr(path, '\\');
    if (lastBackslash == NULL) return NULL;
    *lastBackslash = 0;

    return QString::fromWCharArray(path);
#else
    #error Cannot yet find the executable on this platform
#endif
}
