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
    mainwindow.cpp \
    paths.cpp

HEADERS += \
    mainwindow.h \
    paths.h

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

CONFIG += STATIC

# Include directories for Crashpad libraries
INCLUDEPATH += $$PWD/Crashpad/Include/crashpad
INCLUDEPATH += $$PWD/Crashpad/Include/crashpad/third_party/mini_chromium/mini_chromium

# Crashpad rules for MacOS
macx {
    # Crashpad libraries
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/ -lbase
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/ -lutil
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/ -lclient
    LIBS += "$$PWD/Crashpad/Libraries/MacOS/util/mach/*.o"

    # System libraries
    LIBS += -L/usr/lib/ -lbsm
    LIBS += -framework AppKit
    LIBS += -framework Security

    # Copy crashpad_handler to build directory
    crashpad.commands = mkdir -p $$OUT_PWD/crashpad && cp $$PWD/Crashpad/Bin/MacOS/crashpad_handler $$OUT_PWD/crashpad
    first.depends = $(first) crashpad
    export(first.depends)
    export(copydata.commands)
    QMAKE_EXTRA_TARGETS += first crashpad

    # Run dump_syms and symupload
    QMAKE_POST_LINK += bash $$PWD/Crashpad/Tools/MacOS/symbols.sh $$PWD $$OUT_PWD fred myQtCrasher 1.0 > $$PWD/Crashpad/Tools/MacOS/symbols.out 2>&1
}

# Crashpad rules for Windows
win32 {
    # Build variables
    CONFIG(debug, debug|release) {
        EXEDIR = $$OUT_PWD\debug
    }
    CONFIG(release, debug|release) {
        EXEDIR = $$OUT_PWD\release
    }

    # Crashpad libraries
    LIBS += -L$$PWD/Crashpad/Libraries/Windows/ -lbase
    LIBS += -L$$PWD/Crashpad/Libraries/Windows/ -lclient
    LIBS += -L$$PWD/Crashpad/Libraries/Windows/ -lutil

    # System libraries
    LIBS += -lAdvapi32

    # Copy crashpad
    QMAKE_POST_LINK += "copy /y $$shell_path($$PWD)\Crashpad\Bin\Windows\crashpad_handler.exe $$shell_path($$OUT_PWD)\crashpad"
    QMAKE_POST_LINK += "&& $$shell_path($$PWD)\Crashpad\Tools\Windows\symbols.bat $$shell_path($$PWD) $$shell_path($$EXEDIR) fred myQtCrasher 1.0"
}
