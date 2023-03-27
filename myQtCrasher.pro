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

# Include directories for Crashpad libraries
INCLUDEPATH += $$PWD/Crashpad/Include/crashpad
INCLUDEPATH += $$PWD/Crashpad/Include/crashpad/third_party/mini_chromium/mini_chromium
INCLUDEPATH += $$PWD/Crashpad/Include/crashpad/out/Default/gen

# Crashpad rules for MacOS
macx {
    # Choose either x86_64 or arm64
    #ARCH = x86_64
    ARCH = arm64

    # Crashpad libraries
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/$$ARCH -lcommon
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/$$ARCH -lclient
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/$$ARCH -lbase
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/$$ARCH -lutil
    LIBS += -L$$PWD/Crashpad/Libraries/MacOS/$$ARCH -lmig_output

    # System libraries
    LIBS += -L/usr/lib/ -lbsm
    LIBS += -framework AppKit
    LIBS += -framework Security

    # Copy crashpad_handler to build directory and run dump_syms and symupload
    QMAKE_POST_LINK += "mkdir -p $$OUT_PWD/crashpad"
    QMAKE_POST_LINK += "&& cp $$PWD/Crashpad/Bin/MacOS/$$ARCH/crashpad_handler $$OUT_PWD/crashpad"
    QMAKE_POST_LINK += "&& bash $$PWD/Crashpad/Tools/MacOS/symbols.sh $$PWD $$OUT_PWD fred myQtCrasher 1.0 > $$PWD/Crashpad/Tools/MacOS/symbols.out 2>&1"
    QMAKE_POST_LINK += "&& cp $$PWD/Crashpad/attachment.txt $$OUT_PWD/attachment.txt"
}

# Crashpad rules for Windows
win32 {
    # Build variables
    CONFIG(debug, debug|release) {
        LIBDIR = $$PWD/Crashpad/Libraries/Windows/MDd
        EXEDIR = $$OUT_PWD\debug
    }
    CONFIG(release, debug|release) {
        LIBDIR = $$PWD/Crashpad/Libraries/Windows/MD
        EXEDIR = $$OUT_PWD\release
    }

    # Crashpad libraries
    LIBS += -L$$LIBDIR -lcommon
    LIBS += -L$$LIBDIR -lclient
    LIBS += -L$$LIBDIR -lutil
    LIBS += -L$$LIBDIR -lbase

    # System libraries
    LIBS += -lAdvapi32

    # Copy crashpad_handler to output directory and upload symbols
    QMAKE_POST_LINK += "if not exist $$shell_path($$OUT_PWD)\crashpad mkdir $$shell_path($$OUT_PWD)\crashpad"
    QMAKE_POST_LINK += "&& copy /y $$shell_path($$PWD)\Crashpad\Bin\Windows\crashpad_handler.exe $$shell_path($$OUT_PWD)\crashpad\crashpad_handler.exe"
    QMAKE_POST_LINK += "&& $$shell_path($$PWD)\Crashpad\Tools\Windows\symbols.bat $$shell_path($$PWD) $$shell_path($$EXEDIR) fred myQtCrasher 1.0 > $$shell_path($$PWD)\Crashpad\Tools\Windows\symbols.out 2>&1"
    QMAKE_POST_LINK += "&& copy /y $$shell_path($$PWD)\Crashpad\attachment.txt $$shell_path($$OUT_PWD)\attachment.txt"
}

# Crashpad rules for Linux
linux {
    # Crashpad libraries
    LIBS += -L$$PWD/Crashpad/Libraries/Linux/ -lcommon
    LIBS += -L$$PWD/Crashpad/Libraries/Linux/ -lclient
    LIBS += -L$$PWD/Crashpad/Libraries/Linux/ -lutil
    LIBS += -L$$PWD/Crashpad/Libraries/Linux/ -lbase

    # Copy crashpad_handler to build directory and run dump_syms and symupload
    QMAKE_POST_LINK += "mkdir -p $$OUT_PWD/crashpad && cp $$PWD/Crashpad/Bin/Linux/crashpad_handler $$OUT_PWD/crashpad/crashpad_handler"
    QMAKE_POST_LINK += "&& $$PWD/Crashpad/Tools/Linux/symbols.sh $$PWD $$OUT_PWD fred myQtCrasher 1.0 > $$PWD/Crashpad/Tools/Linux/symbols.out 2>&1"
    QMAKE_POST_LINK += "&& cp $$PWD/Crashpad/attachment.txt $$OUT_PWD/attachment.txt"
}
