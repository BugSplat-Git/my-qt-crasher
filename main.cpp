#include "mainwindow.h"

#if defined(Q_OS_WIN)
#define NOMINMAX
#include <windows.h>
#endif

#if defined(Q_OS_MAC)
#include <mach-o/dyld.h>
#endif

#if defined(Q_OS_LINUX)
#include <unistd.h>
#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#endif

#include <QApplication>
#include <vector>
#include "paths.h"
#include "client/crash_report_database.h"
#include "client/crashpad_client.h"
#include "client/settings.h"

using namespace base;
using namespace crashpad;

bool initializeCrashpad(QString dbName, QString appName, QString appVersion);
QString getExecutableDir(void);

int main(int argc, char *argv[])
{
    QString dbName = "Fred";
    QString appName = "myQtCrasher";
    QString appVersion = "1.2";

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

    // Helper class for cross-platform file systems
    Paths crashpadPaths(exeDir);

    // Ensure that crashpad_handler is shipped with your application
    FilePath handler(Paths::getPlatformString(crashpadPaths.getHandlerPath()));

    // Directory where reports will be saved. Important! Must be writable or crashpad_handler will crash.
    FilePath reportsDir(Paths::getPlatformString(crashpadPaths.getReportsPath()));

    // Directory where metrics will be saved. Important! Must be writable or crashpad_handler will crash.
    FilePath metricsDir(Paths::getPlatformString(crashpadPaths.getMetricsPath()));

    // Configure url with your BugSplat database
    QString url = "https://" + dbName + ".bugsplat.com/post/bp/crash/crashpad.php";

    // Metadata that will be posted to BugSplat
    QMap<std::string, std::string> annotations;
    annotations["format"] = "minidump";                 // Required: Crashpad setting to save crash as a minidump
    annotations["database"] = dbName.toStdString();     // Required: BugSplat database
    annotations["product"] = appName.toStdString();     // Required: BugSplat appName
    annotations["version"] = appVersion.toStdString();  // Required: BugSplat appVersion
    annotations["key"] = "Sample key";                  // Optional: BugSplat key field
    annotations["user"] = "fred@bugsplat.com";          // Optional: BugSplat user email
    annotations["list_annotations"] = "Sample comment"; // Optional: BugSplat crash description
    annotations["attribute"] = "test attribute";        // Optional: BugSplat attribute

    // Disable crashpad rate limiting so that all crashes have dmp files
    std::vector<std::string> arguments;
    arguments.push_back("--no-rate-limit");

    // Initialize crashpad database
    std::unique_ptr<CrashReportDatabase> database = CrashReportDatabase::Initialize(reportsDir);
    if (database == NULL)
        return false;

    // Enable automated crash uploads
    Settings *settings = database->GetSettings();
    if (settings == NULL)
        return false;
    settings->SetUploadsEnabled(true);

    // Attachments to be uploaded alongside the crash - default bundle size limit is 20MB
    std::vector<FilePath> attachments;
    FilePath attachment(Paths::getPlatformString(crashpadPaths.getAttachmentPath()));
    attachments.push_back(attachment);

    // Start crash handler
    CrashpadClient *client = new CrashpadClient();
    bool status = client->StartHandler(handler, reportsDir, metricsDir, url.toStdString(), annotations.toStdMap(), arguments, true, true, attachments);
    return status;
}

QString getExecutableDir()
{
#if defined(Q_OS_MAC)
    unsigned int bufferSize = 512;
    std::vector<char> buffer(bufferSize + 1);

    if (_NSGetExecutablePath(&buffer[0], &bufferSize))
    {
        buffer.resize(bufferSize);
        _NSGetExecutablePath(&buffer[0], &bufferSize);
    }

    char *lastForwardSlash = strrchr(&buffer[0], '/');
    if (lastForwardSlash == NULL)
        return NULL;
    *lastForwardSlash = 0;

    return &buffer[0];
#elif defined(Q_OS_WINDOWS)
    HMODULE hModule = GetModuleHandleW(NULL);
    WCHAR path[MAX_PATH];
    DWORD retVal = GetModuleFileNameW(hModule, path, MAX_PATH);
    if (retVal == 0)
        return NULL;

    wchar_t *lastBackslash = wcsrchr(path, '\\');
    if (lastBackslash == NULL)
        return NULL;
    *lastBackslash = 0;

    return QString::fromWCharArray(path);
#elif defined(Q_OS_LINUX)
    char pBuf[FILENAME_MAX];
    int len = sizeof(pBuf);
    int bytes = MIN(readlink("/proc/self/exe", pBuf, len), len - 1);
    if (bytes >= 0)
    {
        pBuf[bytes] = '\0';
    }

    char *lastForwardSlash = strrchr(&pBuf[0], '/');
    if (lastForwardSlash == NULL)
        return NULL;
    *lastForwardSlash = '\0';

    return QString::fromStdString(pBuf);
#else
#error getExecutableDir not implemented on this platform
#endif
}
