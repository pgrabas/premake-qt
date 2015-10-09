
--
-- To avoid qt.lua re-including _preload
--
premake.extensions.qt = true


--
-- Set the path where Qt is installed
--
premake.api.register {
	name = "qtpath",
	scope = "config",
	kind = "path"
}

--
-- Set the path where Qt headers are located
--
premake.api.register {
	name = "qtheaderpath",
	scope = "config",
	kind = "path"
}

--
-- Set the prefix of the libraries ("Qt4" or "Qt5" usually)
--
premake.api.register {
	name = "qtprefix",
	scope = "config",
	kind = "string"
}

--
-- Set a suffix for the libraries ("d" usually when using Debug Qt libs)
--
premake.api.register {
	name = "qtsuffix",
	scope = "config",
	kind = "string"
}

--
-- Set a suffix for the library files
--
premake.api.register {
	name = "qtlibsuffix",
	scope = "config",
	kind = "string"
}

--
-- Specify the modules to use (will handle include paths, links, etc.)
-- See premake.extensions.qt.modules for a list of available modules.
--
premake.api.register {
	name = "qtmodules",
	scope = "config",
	kind = "string-list"
}

--
-- Specify the path, relative to the current script, where the files generated
-- by Qt will be created. If this command is not used, the default behavior
-- is to generate those files in the objdir.
--
premake.api.register {
	name = "qtgenerateddir",
	scope = "config",
	kind = "path"
}

--
-- Specify a list of custom options to send to the Qt moc command line.
--
premake.api.register {
	name = "qtmocargs",
	scope = "config",
	kind = "string-list"
}

--
-- Specify a list of custom options to send to the Qt uic command line.
--
premake.api.register {
	name = "qtuicargs",
	scope = "config",
	kind = "string-list"
}

--
-- Specify a list of custom options to send to the Qt rcc command line.
--
premake.api.register {
	name = "qtrccargs",
	scope = "config",
	kind = "string-list"
}

--
-- Private use only : used by the addon to know if qt has already been enabled or not
--
premake.api.register {
	name = "qtenabled",
	scope = "project",
	kind = "boolean"
}


--
-- Always load
--
return function () return true end
