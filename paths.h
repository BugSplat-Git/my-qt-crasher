#ifndef PATHS_H
#define PATHS_H

#include <QApplication>

class Paths
{
    QString m_exeDir;

    public:
        Paths(QString exeDir);
        QString getAttachmentPath();
        QString getHandlerPath();
        QString getReportsPath();
        QString getMetricsPath();
        #if defined(Q_OS_UNIX)
            static std::string getPlatformString(QString string);
        #elif defined(Q_OS_WINDOWS)
            static std::wstring getPlatformString(QString string);
        #else
            #error getPlatformString not implemented on this platform
        #endif
};

#endif // PATHS_H
