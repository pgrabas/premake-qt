Qt Addon
========

This addon allows you to generate a projects / solutions with Qt support by
automatically adding the correct custom build command to handle the Qt specific
stuff (such as invoking the `moc` command, the `uic` one, etc.)

**Beware though that those custom rules are only created when the solutions /
projects are built using Premake** ! You need to re-run Premake when adding
new Qt classes, UIs, etc. or when you add **Q_OBJECT** to one of your existing
classes.

Please feel free to drop a comment, issue or whatever if you notice a bug. Also,
if you take the time to do so, please also take the time to create a small
reproductible scenario that you can attach to the issue :)


How to use
==========

Clone this repository some place where Premake will be able to find it. Then
in your project's Premake script, include the main file like this :

```lua
require( "premake-qt/qt.lua" )

-- this line is optional, but it avoids writting premake.extensions.qt to
-- call the plugin's methods.
local qt = premake.extensions.qt
```

Then in the projects that you want to enable to Qt, just add this :

```lua
-- be carefull, this function enables Qt only for the current configuration.
-- So if you want to enable it on all configuration, be sure that no filter
-- is active when calling this (or reset the filter using `filter {}`
qt.enable()
```


API
===

The following API commands will allow you to customize Qt: what version are
you building against, what custom options do you want to send to the Qt build
tools, etc. They only have an effect if the project has been enabled to Qt.

Most of the API commands of this addon are scoped to the current configuration,
so unless specified otherwise, assume that the documented command only applies
to the current configuration block.

#####qtpath "path"

Setup the path where Qt include and lib folders are found. If this is not used,
the addon will try to get the path from the `QTDIR` or `QT_DIR` environment variable.

#####qtheaderpath "path"

Alternative location Qt headers. If not provided defaults to value of qtpath.

#####qtprefix "prefix"

Specify a prefix used by the libs. For instance, when using the default Qt5
installation, for the widgets module, the lib is named `Qt5Widgets.lib`, so you
must set `Qt5` as the prefix.

#####qtsuffix "suffix"

This one is only used when linking against debug or custom versions of Qt. For
instance, in debug, the libs are suffixed with a `d`. And when building your
own version of Qt, you might want to suffix the x64 and x86 versions differently.

#####qtlibsuffix "libsuffix"

Default value is .lib in order to maintain capabilty with original premake-qt.
This setting allows to change qt libraries type instead of allways added .lib.
This change allows to build qt applications with preamke-qt on Linux where 
libraries may have extension .a or .so.

#####qtmodules { "module", "module", ...}

Specify which module you want to use. The available modules are (for the moment)

* [core](http://doc.qt.io/qt-5/qtcore-index.html)
* [gui](http://doc.qt.io/qt-5/qtgui-index.html)
* [multimedia](http://doc.qt.io/qt-5/qtmultimedia-index.html)
* [network](http://doc.qt.io/qt-5/qtnetwork-index.html)
* [opengl](http://doc.qt.io/qt-5/qtopengl-index.html)
* [positioning](http://doc.qt.io/qt-5/qtpositioning-index.html)
* [printsupport](http://doc.qt.io/qt-5/qtprintsupport-index.html)
* [qml](http://doc.qt.io/qt-5/qtqml-index.html)
* [quick](http://doc.qt.io/qt-5/qtquick-index.html)
* [sensors](http://doc.qt.io/qt-5/qtsensors-index.html)
* [sql](http://doc.qt.io/qt-5/qtsql-index.html)
* [svg](http://doc.qt.io/qt-5/qtsvg-index.html)
* [testlib](http://doc.qt.io/qt-5/qttest-index.html)
* [websockets](http://doc.qt.io/qt-5/qtwebsockets-index.html)
* [widgets](http://doc.qt.io/qt-5/qtwidgets-index.html)
* [xml](http://doc.qt.io/qt-5/qtxml-index.html)

Using a module will add its include folder, and link the correct librar(y/ies)
The list of module can be customized. See the Examples section for more information.

#####qtgenerateddir "path"

The optional path where Qt generated file are created. If omitted, those files
are generated in the objdir.

#####qtmocargs { "arg", "arg", ... }

An optional list of arguments that will be sent to the Qt moc tool. Each argument will be encased
in double quotes, e.g. `qtmocargs { "foo", "bar" }` will appear as `"foo" "bar"` in the command line.

#####qtuicargs { "arg", "arg", ... }

An optional list of arguments that will be sent to the Qt uic tool. Each argument will be encased
in double quotes, e.g. `qtuicargs { "foo", "bar" }` will appear as `"foo" "bar"` in the command line.

#####qtrccargs { "arg", "arg", ... }

An optional list of arguments that will be sent to the Qt rcc tool. Each argument will be encased
in double quotes, e.g. `qtrccargs { "foo", "bar" }` will appear as `"foo" "bar"` in the command line.


Examples
========

Basic Use
---------

Here is a small example of how to use the addon :

Visual Studio:
```lua
--
-- Include the Qt functionalities and create a shortcut
--
require( "premake-qt/qt.lua" )
local qt = premake.extensions.qt

-- main solution
solution "TestQt"

	--
	-- setup your solution's configuration here ...
	--

	-- main project
	project "TestQt"

		--
		-- setup your project's configuration here ...
		--

		-- add the files
		files { "**.h", "**.cpp", "**.ui" "**.qrc" }


		--
		-- Enable Qt for this project.
		--
		qt.enable()

		--
		-- Setup the Qt path. This apply to the current configuration, so
		-- if you handle x32 and x64, you can specify a different path
		-- for both configurations.
		--
		-- Note that if this is ommited, the addon will try to look for the
		-- QTDIR environment variable. If it's not found, then the script
		-- will return an error since it won't be able to find the path
		-- to your Qt installation.
		--
		qtpath "C:/Qt/5.1"

		--
		-- Setup which Qt modules will be used. This also apply to the
		-- current configuration, so can you choose to deactivate a module
		-- for a specific configuration.
		--
		qtmodules { "core", "gui", "widgets", "opengl" }

		--
		-- Setup the prefix of the Qt libraries. Usually it's Qt4 for Qt 4.x
		-- versions and Qt5 for Qt 5.x ones. Again, this apply to the current
		-- configuration. So if you want to have a configuration which uses
		-- Qt4 and one that uses Qt5, you can do it.
		--
		qtprefix "Qt5"

		--
		-- Setup the suffix for the Qt libraries. The debug versions of the
		-- Qt libraries usually have a "d" suffix. If you compiled your own
		-- version, you could also have suffixes for x64 libraries, etc.
		--
		configuration { "Debug" }
			qtsuffix "d"
		configuration { }
```


Linux and gmake action:
```lua
require( "premake-qt/qt.lua" )
local qt = premake.extensions.qt

solution "TestQt"
	project "TestQt"
		files { "**.h", "**.cpp", "**.ui" "**.qrc" }
		location "bin"
		
		qt.enable()
		qtpath "/usr"
		qtheaderpath "/usr/include/qt/"
		qtmodules { "core", "gui", "widgets", "opengl" }
		qtprefix "Qt5"
		qtlibsuffix "" -- this also works under Visual Studio
		
		links "TestQt_ui"

		configuration { "Debug" }
			qtsuffix "d"
		configuration { }
		
	project "TestQt_ui" --this is not a beautiful solution, but it works
		files { "**.ui" }
		location "bin" -- location must be the same as the parent project
		
		qt.enable()
		qtpath "/usr"
		qtheaderpath "/usr/include/qt"
		qtmodules { "core", "gui", "widgets", "opengl" }
		qtprefix "Qt5"
	
```

In the example above shows how to overcome issue when ui files are not processed before
corresponding cpp files.

Adding modules
--------------

You can add modules to the addon like this :

```lua
--
-- Include the Qt functionalities and create a shortcut
--
require( "premake-qt/qt.lua" )
local qt = premake.extensions.qt

--
-- modules is a table where the key is a string identifying the module (the
-- strings that you use with the `qtmodules` command)
-- the value is an object containing the following members :
--    * name    : The name of the module. It's the part which appears
--                in the lib and dll names without the suffixes and prefixes.
--                For instance for core, it's "Core".
--    * include : This is the include folder for the module, relative to the base
--                Qt include path. For instance for core, it's "QtCore"
--    * links   : This an optional list of links to add. For instance for the opengl
--                module, we need to link against OpenGL lib, so it's { "OpenGL32" }
--    * defines : Specify one or more defines to add when using the module. It can
--                be a string or a list of string. For instance { "QT_GUI_LIB" } for gui module.
--
-- Here, we add support for xml (well, it's already supported, but it's for the example's sake :)
--
qt.modules["xml"] = {
	name = "Xml",
	include = "QtXml",
	defines = "QT_XML_LIB"
}

--
-- then you can just use the newly added module like the other ones, the addon
-- will take care of linking the library, adding the suffixes, etc.
--
qdtmodules { "core", "xml" }
```
