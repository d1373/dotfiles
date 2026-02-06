-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

require("config.error_handling").setup()

local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local vars = require("config.vars")
terminal = vars.terminal
editor = vars.editor
editor_cmd = vars.editor_cmd
modkey = vars.modkey
altkey = vars.altkey

require("config.layouts").setup()

local menu = require("config.menu").setup(vars)
mymainmenu = menu.mainmenu
mylauncher = menu.launcher
myawesomemenu = menu.awesomemenu

mykeyboardlayout = awful.widget.keyboardlayout()

require("config.appearance").setup()
require("config.widgets.wibar").setup({ modkey = vars.modkey })

local mouse = require("config.bindings.mouse").setup({ modkey = vars.modkey, mainmenu = menu.mainmenu })
local keys = require("config.bindings.keys").setup({
	modkey = vars.modkey,
	altkey = vars.altkey,
	terminal = vars.terminal,
})

require("config.rules").setup({
	clientkeys = keys.clientkeys,
	clientbuttons = mouse.clientbuttons,
})

require("config.signals").setup()
require("config.autostart").setup()
