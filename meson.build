project('qt-crasher', 'cpp',
	version : '2.7.0.0',
	default_options : [ 'warning_level=0', 'cpp_std=c++17' ])


qt5 = import('qt5')
qt5dep = dependency('qt5', modules :  [ 'Core', 'GUI', 'Widgets', 'SQl', 'svg',
				'Network', 'Location', 'WebEngineWidgets', 'Concurrent', 'Positioning',  ],
		#main:true causes linkage with "qtmain.lib", this adds 'winMain', needed for guiapps on windows
		#not sure what else it does
		main:true)


ProjectDir = meson.current_source_dir()
cc = meson.get_compiler('cpp')

assert(cc.get_id() == 'clang', 'This Setup has only been tested for the Clang compiler')


buildtype = get_option('buildtype')
if buildtype == 'release'
	qt_dll_postfix = ''
	crashpad_lib_dir = ProjectDir / 'Crashpad/Libraries/Windows/MD'
	buildtype_cpp_args = [ '-DQT_NO_DEBUG=1' ]
	buildtype_link_args = [ '-lmsvcrt', '-lucrt', '-lmsvcprt', '-lvcruntime' ]
	message('release')
else
	qt_dll_postfix = 'd'
	crashpad_lib_dir = ProjectDir / 'Crashpad/Libraries/Windows/MDd'
	buildtype_cpp_args = [ '-DQT_DEBUG=1', '-D_DEBUG' ]
	buildtype_link_args = [ '-lmsvcrtd', '-lucrtd', '-lmsvcprtd', '-lvcruntimed', '-D_DEBUG' ]
	message('debug')
endif


crashpad_inc = include_directories([
	ProjectDir / 'Crashpad/Include/Crashpad',
	ProjectDir / 'Crashpad/Include/crashpad/third_party/mini_chromium/mini_chromium',
	ProjectDir / 'Crashpad/Include/crashpad/out/Default/gen'
])

Crashdir_Lib1 = cc.find_library(
	'base',
	dirs: crashpad_lib_dir
)

Crashdir_Lib2 = cc.find_library(
	'common',
	dirs: crashpad_lib_dir
)

Crashdir_Lib3 = cc.find_library(
	'client',
	dirs: crashpad_lib_dir
)

Crashdir_Lib4 = cc.find_library(
	'util',
	dirs: crashpad_lib_dir
)



src_files = files('main.cpp', 
	'mainwindow.cpp', 
	'paths.cpp'
)

header = files(
	'mainwindow.h', 
	'paths.h'
)

ui_files = files('mainwindow.ui')

res_files = files(['myQtCrasher.qrc'])


add_project_arguments(
	# Optimization flags
	[
	#'-Ofast',
	],
	language:'cpp'
)


#copies listed Qt .dlls into output directory
qpath = meson.get_external_property('qpath')

qt5dll = [ 'Concurrent', 'Core', 'GUI', 'Location',
		'Network', 'SQl', 'svg', 'WebEngineWidgets', 'Widgets',
		'WebEngineCore', 'Qml', 'QuickWidgets', 'Quick', 'PrintSupport',
		'Positioning', 'WebChannel' ]
foreach dllname: qt5dll
	dllname = 'Qt5' + dllname + qt_dll_postfix + '.dll'
	configure_file(input: qpath + dllname, output: dllname, copy: true)
endforeach


ui_comp = qt5.preprocess(ui_files: ui_files, 
	moc_headers: [ header ],
	moc_extra_arguments : [ buildtype_cpp_args ],
	qresources : [ res_files ],
	dependencies: [ qt5dep ]
)


exec = executable('myQtCrasher',
	sources: [ src_files, ui_comp ],
	dependencies: [ qt5dep, 
		Crashdir_Lib1, Crashdir_Lib2,
		Crashdir_Lib3, Crashdir_Lib4 ],
	include_directories: [ crashpad_inc ],
	cpp_args: [ buildtype_cpp_args, '-D_DLL', '-D_MT' ],
	link_args: [ buildtype_link_args, '-D_DLL', '-D_MT' ]
)

configure_file(
	input: ProjectDir / 'Crashpad/Bin/Windows/crashpad_handler.exe',
	output: 'crashpad_handler.exe',
	copy: true)


configure_file(
	input: ProjectDir / 'Crashpad/attachment.txt',
	output: 'attachment.txt',
	copy: true)

#QMAKE_POST_LINK += "&& $$shell_path($$PWD)\Crashpad\Tools\Windows\symbols.bat $$shell_path($$PWD) $$shell_path($$EXEDIR) fred myQtCrasher 1.0 > $$shell_path($$PWD)\Crashpad\Tools\Windows\symbols.out 2>&1"
