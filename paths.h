#ifndef PATHS_H
#define PATHS_H

#include <QApplication>
using namespace std;

class Paths
{
    QString m_exeDir;

    public:
        Paths(QString exeDir);
        QString getAttachmentPath();
        QString getHandlerPath();
        QString getReportsPath();
        QString getMetricsPath();
        #if defined(Q_OS_MACOS) || defined(Q_OS_LINUX)
            static string getPlatformString(QString string);
        #elif defined(Q_OS_WINDOWS)
            static wstring getPlatformString(QString string);
        #else
            #error getPlatformStrinn not implemented on this platform
        #endif
};

#endif // PATHS_H
