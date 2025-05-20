[![bugsplat-github-banner-basic-outline](https://user-images.githubusercontent.com/20464226/149019306-3186103c-5315-4dad-a499-4fd1df408475.png)](https://bugsplat.com)
<br/>
# <div align="center">BugSplat</div> 
### **<div align="center">Crash and error reporting built for busy developers.</div>**
<div align="center">
    <a href="https://twitter.com/BugSplatCo">
        <img alt="Follow @bugsplatco on Twitter" src="https://img.shields.io/twitter/follow/bugsplatco?label=Follow%20BugSplat&style=social">
    </a>
    <a href="https://discord.gg/K4KjjRV5ve">
        <img alt="Join BugSplat on Discord" src="https://img.shields.io/discord/664965194799251487?label=Join%20Discord&logo=Discord&style=social">
    </a>
</div>

## 👋 Introduction

This sample demonstrates cross-platform crash reporting with [BugSplat](https://bugsplat.com), [Crashpad](https://chromium.googlesource.com/crashpad/crashpad/+/master/README.md), and [Qt](https://www.qt.io/). Additionally, my-qt-crasher uses [symbol-upload](https://github.com/BugSplat-Git/symbol-upload) to generate [symbol files](https://chromium.googlesource.com/breakpad/breakpad/+/master/docs/symbol_files.md) and upload them to BugSplat

For more information about how to configure Crashpad in your Qt application please see the BugSplat [docs](https://docs.bugsplat.com/introduction/getting-started/integrations/cross-platform/qt).

## 📋 Steps

1. Download and install [Qt Creator](https://www.qt.io/download)
2. Open myQtCrasher.pro
3. Build > Run to run without the debugger attached
4. Click the button to generate a crash report
5. Log into BugSplat using our public account fred@bugsplat.com and the password Flintstone
6. Click the link in the ID column on the [Crashes](https://app.bugsplat.com/v2/crashes?database=Fred&c0=appName&f0=EQUAL&v0=myQtCrasher) page to see detailed information similar to what you would see in your debugger

**Crashes Page**
<img width="1728" alt="BugSplat Crashes Page" src="https://github.com/BugSplat-Git/my-qt-crasher/assets/2646053/174d9e4e-f55d-4a25-b604-252912cd6c67">

**Crash Page**
<img width="1728" alt="BugSplat Crash Page" src="https://github.com/BugSplat-Git/my-qt-crasher/assets/2646053/19f4efad-aea7-47fe-b410-1b87922e7329">

### Windows

When building your Qt project you may encounter `Il mismatch between 'P1' version 'x' and 'P2' version 'y'`. This is due to Qt building with a different toolchain than the Crashpad libraries. To workaround the `Il mismatch` issue, build Crashpad specifying `/GL-` for `extra_cflags`. When Crashpad is built with different minor versions of MSVC specifying `/GL-` usually fixes the problem. However, if the linker complains about unresolved symbols after specifying `/GL-` you will need to ensure you're building with the same major version of MSVC. The pre-built Crashpad libraries included in this sample are built with MSVC 17 (2022).

### macOS

You will need to link with the correct libraries and load the correct version of `crashpad_handler` at runtime depending on if your build is targeting x86_64 or arm64 (M1) macOS systems. In `myQtCrasher.pro` there is an variable that you can [uncomment](https://github.com/BugSplat-Git/my-qt-crasher/blob/4a6b1e9cb6084963fd457e745e9142db9c05f063/myQtCrasher.pro#L51) that will allow you to build for arm64 macOS systems.

**Attachments**

BugSplat has created a [Crashpad fork](https://github.com/BugSplat-Git/crashpad) that adds support for attachments to macOS. This project uses pre-built binaries from the forked version of Crashpad to demonstrate attachment support on macOS. If attachment support on macOS is a requirement for your project, you can use the pre-built libraries from this repo, or build the Crashpad libraries yourself from the code in our forked repo.

### Additional Considerations

If you change the BugSplat `database`, `application`, or `version` values in `main.cpp`, be sure to update the corresponding variables in the [myQtCrasher.pro file](https://github.com/BugSplat-Git/my-qt-crasher/blob/fc55bad38929f21a431c965abcfd3a17b1b91e45/myQtCrasher.pro#L38-L43). The `symbols.sh` scripts are responsible for running `symbol-upload` on macOS and Linux. Likewise, `symbols.ps1` is responsible for running `symbol-upload` on Windows. If the values passed to `symbols.sh` or `symbols.ps1` via the `QMAKE_POST_LINK` command are wrong then you will not see file names or line numbers in your crash reports.

## 👷 Support

If you have any additional questions, please email our [support](mailto:support@bugsplat.com) team, join us on [Discord](https://discord.gg/bugsplat), or reach out via the chat in our web application.
