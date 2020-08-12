#include "paths.h"

Paths::Paths(QString exeDir) {
    m_exeDir = exeDir;
}

QString Paths::getAttachmentPath() {
    #if defined(Q_OS_MACOS)
        return m_exeDir + "/../attachment.txt";
    #elif defined(Q_OS_WINDOWS)
        return m_exeDir + "\\..\\attachment.txt";
    #elif defined(Q_OS_LINUX)
        return m_exeDir + "/attachment.txt";
    #else
        #error getAttachmentPath() not implemented on this platform
    #endif
}

QString Paths::getHandlerPath() {
    #if defined(Q_OS_MACOS)
        return m_exeDir + "/../../../crashpad/crashpad_handler";
    #elif defined(Q_OS_WINDOWS)
        return m_exeDir + "\\..\\crashpad\\crashpad_handler.exe";
    #elif defined(Q_OS_LINUX)
        return m_exeDir + "/crashpad/crashpad_handler";
    #else
        #error getHandlerPath not implemented on this platform
    #endif
}

QString Paths::getReportsPath() {
    #if defined(Q_OS_MACOS)
        return m_exeDir + "/../../../crashpad";
    #elif defined(Q_OS_WINDOWS)
        return m_exeDir + "\\..\\crashpad";
    #elif defined(Q_OS_LINUX)
        return m_exeDir + "/crashpad";
    #else
        #error getReportsPath not implemented on this platform
    #endif
}

QString Paths::getMetricsPath() {
    #if defined(Q_OS_MACOS)
        return m_exeDir + "/../../../crashpad";
    #elif defined(Q_OS_WINDOWS)
        return m_exeDir + "\\..\\crashpad";
    #elif defined(Q_OS_LINUX)
        return m_exeDir + "/crashpad";
    #else
        #error getMetricsPath not implemented on this platform
    #endif
}

#if defined(Q_OS_MACOS) || defined(Q_OS_LINUX)
string Paths::getPlatformString(QString string){
    return string.toStdString();
}
#elif defined(Q_OS_WINDOWS)
wstring Paths::getPlatformString(QString string) {
    return string.toStdWString();
}
#else
    #error getPlatformString not implemented on this platform
#endif
