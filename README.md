[![BugSplat](https://s3.amazonaws.com/bugsplat-public/npm/header.png)](https://www.bugsplat.com)

# myQtCrasher

This sample demonstrates cross-platform crash reporting with BugSplat, Crashpad, and Qt. MyQtCrasher includes prebuilt versions of Crashpad for Windows, macOS (x86_64 and arm64), and Linux. Additionally, this sample demonstrates how to use the Breakpad tools `dump_syms` and `symupload` to create and upload `.sym` files as part of your Qt build.

## Steps
1. Download and install [Qt Creator](https://www.qt.io/download)
2. Open myQtCrasher.pro
3. Build > Run to run without the debugger attached
4. Click the button to generate a crash report
5. Log into BugSplat using our public account fred@bugsplat.com and the password Flintstone
6. Click the link in the ID column on the [Crashes](https://app.bugsplat.com/v2/crashes?database=Fred&c0=appName&f0=EQUAL&v0=myQtCrasher) page to see detailed information similar to what you would see in your debugger

## macOS

You will need to link with the correct libraries and load the correct version of `crashpad_handler` at runtime depending on if your build is targeting x86_64 or arm64 (M1) macOS systems. In `myQtCrasher.pro` there is an variable that you can [uncomment](https://github.com/BugSplat-Git/my-qt-crasher/blob/4a6b1e9cb6084963fd457e745e9142db9c05f063/myQtCrasher.pro#L51) that will allow you to build for arm64 macOS systems.

## Other

If you change the database, application and version in `main.cpp`, be sure to update the `QMAKE_POST_LINK` command with these new values. `symbols.sh` is responsible for running `dump_syms` and `symupload` on macOS and Linux. `symbols.bat` is responseible for running `symupload` on Windows. If the values passed to `symbols.sh` or `symbols.bat` via the `QMAKE_POST_LINK` command are wrong then you will not see file names or line numbers in your crash reports.
