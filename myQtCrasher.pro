QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    myQtCrasher.qrc

# Create a dSYM file for dump_syms
CONFIG += force_debug_info
CONFIG += separate_debug_info

# Include directories for Crashpad libraries
INCLUDEPATH += $$_PRO_FILE_PWD_/Crashpad/Include/crashpad
INCLUDEPATH += $$_PRO_FILE_PWD_/Crashpad/Include/crashpad/third_party/mini_chromium/mini_chromium

# Crashpad rules for MacOS
macx {
    # Crashpad libraries
    LIBS += -L$$_PRO_FILE_PWD_/Crashpad/Libraries/MacOS/ -lbase
    LIBS += -L$$_PRO_FILE_PWD_/Crashpad/Libraries/MacOS/ -lutil
    LIBS += -L$$_PRO_FILE_PWD_/Crashpad/Libraries/MacOS/ -lclient
    LIBS += "$$_PRO_FILE_PWD_/Crashpad/Libraries/MacOS/util/mach/*.o"

    # System libraries
    LIBS += -L/usr/lib/ -lbsm
    LIBS += -framework AppKit
    LIBS += -framework Security
}
