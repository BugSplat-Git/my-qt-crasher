[![BugSplat](https://s3.amazonaws.com/bugsplat-public/npm/header.png)](https://www.bugsplat.com)

# myQtCrasher

This sample demonstrates cross-platform crash reporting with BugSplat, Crashpad and Qt. This sample comes with prebuilt versions of Crashpad for Windows and MacOS. Additionally, this sample demonstrates how to use the Breakpad tools dump_syms and sym_upload to create and upload .sym files automatically as part of your Qt build.

## Steps
1. Download and install [Qt Creator](https://www.qt.io/download)
2. Open myQtCrasher.pro
3. Build > Run to run without the debugger attached
4. Click the button to generate a crash report
5. Log into BugSplat using our public account fred@bugsplat.com and the password Flintstone
6. Click the link in the ID column on the [Crashes](https://app.bugsplat.com/v2/crashes?database=Fred&c0=appName&f0=EQUAL&v0=myQtCrasher) page to see detailed information similar to what you would see in your debugger

## Other

If you change the database, application and version in main.cpp, be sure to update the QMAKE_POST_LINK command with these new values. Symbols.sh is responsible for running dump_syms and symupload on MacOS. Symbols.bat is responseible for running symupload on Windows. If the values passed to symbols.sh or symbols.bat via the QMAKE_POST_LINK command are wrong then you will not see file names or line numbers in your crash reports.
