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

bool initializeCrashpad(char *dbName, char *appName, char *appVersion);
string getExecutableDir(void);

int main(int argc, char *argv[])
{
    char *dbName = (char *)"Fred";
    char *appName = (char *)"myQtCrasher";
    char *appVersion = (char *)"1.0";

    initializeCrashpad(dbName, appName, appVersion);

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}

bool initializeCrashpad(char *dbName, char *appName, char *appVersion )
{
    // Get directory where the exe lives so we can pass a full path to handler, reportsDir and metricsDir
    string exeDir = getExecutableDir();

    // Ensure that handler is shipped with your application
    FilePath handler(exeDir + "/../../../crashpad/crashpad_handler");

    // Directory where reports will be saved. Important! Must be writable or crashpad_handler will crash.
    FilePath reportsDir(exeDir + "/../../../crashpad");

    // Directory where metrics will be saved. Important! Must be writable or crashpad_handler will crash.
    FilePath metricsDir(exeDir + "/../../../crashpad");

    // Configure url with your BugSplat database
    string url;
    url = "https://";
    url += dbName;
    url += ".bugsplat.com/post/bp/crash/crashpad.php";

    // Metadata that will be posted to BugSplat
    map<string, string> annotations;
    annotations["format"] = "minidump";                 // Required: Crashpad setting to save crash as a minidump
    annotations["product"].assign(appName);             // Required: BugSplat appName
    annotations["version"].assign(appVersion);      	// Required: BugSplat appVersion
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
    bool status = client->StartHandler(handler, reportsDir, metricsDir, url, annotations, arguments, true, true);
    return status;
}

string getExecutableDir() {
    unsigned int bufferSize = 512;
    vector<char> buffer(bufferSize + 1);

#if defined(Q_OS_MACOS)
    if(_NSGetExecutablePath(&buffer[0], &bufferSize))
    {
        buffer.resize(bufferSize);
        _NSGetExecutablePath(&buffer[0], &bufferSize);
    }

    char* lastForwardSlash = strrchr(&buffer[0], '/');
    if (lastForwardSlash == NULL) return NULL;
    *lastForwardSlash = 0;

#else
    #error Cannot yet find the executable on this platform
#endif

    return &buffer[0];
}
