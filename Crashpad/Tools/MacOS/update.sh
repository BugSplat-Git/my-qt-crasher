# Variables
CRASHPAD_DIR="/Users/bobby/Desktop/bugsplat/crashpad/crashpad"
CRASHPAD_GN="out/Default"
CRASHPAD_OUT="$CRASHPAD_DIR/$CRASHPAD_GN"
PROJECT_DIR="/Users/bobby/Desktop/bugsplat/my-qt-crasher"

# Start in the Crashpad dir
cd $CRASHPAD_DIR

# Update Crashpad
git pull -r
gclient sync

# Build Crashpad
ninja -C $CRASHPAD_OUT

# Copy .h Includess
rsync -avh --include='*/' --include='*.h' --exclude='*' --prune-empty-dirs ./ $PROJECT_DIR/Crashpad/Include/crashpad 

# Copy Libraries
cp $CRASHPAD_OUT/obj/client/libcommon.a $PROJECT_DIR/Crashpad/Libraries/MacOS 
cp $CRASHPAD_OUT/obj/client/libclient.a $PROJECT_DIR/Crashpad/Libraries/MacOS 
cp $CRASHPAD_OUT/obj/util/libutil.a $PROJECT_DIR/Crashpad/Libraries/MacOS
cp $CRASHPAD_OUT/obj/third_party/mini_chromium/mini_chromium/base/libbase.a $PROJECT_DIR/Crashpad/Libraries/MacOS
cp $CRASHPAD_OUT/obj/util/libmig_output.a $PROJECT_DIR/Crashpad/Libraries/MacOS

# Copy Handler
cp $CRASHPAD_OUT/crashpad_handler $PROJECT_DIR/Crashpad/Bin/MacOS
