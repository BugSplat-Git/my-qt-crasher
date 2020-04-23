# myQtCrasher
Example Qt application integrated with Crashpad. 

## Steps
1. Download and install [Qt](https://www.qt.io/download)
2. Open myQtCrasher.pro
3. Build > Run to run without the debugger attached

## Other

If you change the database, application and version in main.cpp, be sure to update the QMAKE_POST_LINK command with these new values. Symbols.sh is responsible for running dump_syms and symupload. If the values passed to symbols.sh via the QMAKE_POST_LINK command are wrong then you will not see file names or line numbers in your crash reports.
