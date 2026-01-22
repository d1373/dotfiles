-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require("collision")()
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end
-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "ghostty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	--awful.layout.suit.tile.left,
	--awful.layout.suit.tile.bottom,
	--awful.layout.suit.tile.top,
	--awful.layout.suit.fair,
	--awful.layout.suit.fair.horizontal,
	--awful.layout.suit.spiral,
	--awful.layout.suit.spiral.dwindle,
	--awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.sw,
	--awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a %b %d %H:%M")

local bar_bg = beautiful.bar_bg or "#101013"
local bar_accent = beautiful.bar_accent or beautiful.fg_focus
local bar_fg = beautiful.bar_fg or "#ffffff"

local function make_text(text)
	local widget = wibox.widget.textbox()
	widget:set_markup("<span foreground='" .. bar_fg .. "'>" .. text .. "</span>")
	return widget
end

local function make_separator()
	return make_text(" | ")
end

local icon_font = beautiful.icon_font or beautiful.font
local icon_font_small = beautiful.icon_font_small or icon_font

local function make_icon_widget(glyph)
	local widget = wibox.widget.textbox()
	widget.font = icon_font
	widget.valign = "center"
	widget.align = "center"
	widget:set_markup("<span foreground='" .. bar_accent .. "'>" .. glyph .. "</span>")
	return widget
end

local volume_icon = make_icon_widget("󰕾")
local volume_widget = wibox.container.place(volume_icon, "center", "center")
volume_widget:buttons(gears.table.join(
	awful.button({}, 1, function()
		awful.spawn("pavucontrol")
	end),
	awful.button({}, 4, function()
		awful.spawn("pulsemixer --change-volume +5")
	end),
	awful.button({}, 5, function()
		awful.spawn("pulsemixer --change-volume -5")
	end)
))

local clock_widget = wibox.container.background(mytextclock)
clock_widget.fg = bar_fg

local volume_text = wibox.widget.textbox()
volume_text.valign = "center"
volume_text.font = beautiful.font
volume_text:set_markup("<span foreground='" .. bar_fg .. "'>--%</span>")

awful.widget.watch("pulsemixer --get-volume", 1, function(widget, stdout)
	local level = stdout:match("(%d+)")
	if level then
		widget:set_markup("<span foreground='" .. bar_fg .. "'>" .. level .. "%</span>")
	end
end, volume_text)

local battery_icon = make_icon_widget("󰁹")
local battery_widget = wibox.container.place(battery_icon, "center", "center")
battery_widget:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn.with_shell([[
mode=$(powerprofilesctl get 2>/dev/null || echo "")
case "$mode" in
	performance) next=balanced ;;
	balanced) next=power-saver ;;
	power-saver) next=performance ;;
	*) next=balanced ;;
esac
powerprofilesctl set "$next"
]])
end)))

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(27)
systray.forced_height = 27

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
	})

	-- Focused client widget (icon + name)
	s.myfocus = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused,
		buttons = tasklist_buttons,
		layout = { layout = wibox.layout.fixed.horizontal },
		widget_template = {
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				spacing = 8,
				layout = wibox.layout.fixed.horizontal,
			},
			id = "background_role",
			widget = wibox.container.background,
			create_callback = function(self)
				self.bg = beautiful.bg_focus
				self.fg = bar_fg
			end,
			update_callback = function(self)
				self.bg = beautiful.bg_focus
				self.fg = bar_fg
			end,
		},
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, bg = bar_bg, height = 30 })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			s.mytaglist,
			s.myfocus,
		},
		wibox.widget.textbox(""), -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			systray,
			make_separator(),
			battery_widget,
			volume_widget,
			volume_text,
			make_separator(),
			clock_widget,
			s.mylayoutbox,
		},
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end)
	--awful.button({ }, 4, awful.tag.viewnext),
	--awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	-- awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- Focus client by direction
	awful.key({ modkey }, "h", function()
		awful.client.focus.bydirection("left")
	end, { description = "focus left", group = "client" }),

	awful.key({ modkey }, "l", function()
		awful.client.focus.bydirection("right")
	end, { description = "focus right", group = "client" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.bydirection("down")
	end, { description = "focus down", group = "client" }),

	awful.key({ modkey }, "k", function()
		awful.client.focus.bydirection("up")
	end, { description = "focus up", group = "client" }),
	awful.key({ altkey }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next", group = "client" }),
	awful.key({ altkey, "Shift" }, "Tab", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous", group = "client" }),
	-- Swap client by direction
	awful.key({ modkey, "Shift" }, "h", function()
		awful.client.swap.bydirection("left")
	end, { description = "swap with left", group = "client" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.client.swap.bydirection("right")
	end, { description = "swap with right", group = "client" }),

	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.bydirection("down")
	end, { description = "swap with down", group = "client" }),

	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.bydirection("up")
	end, { description = "swap with up", group = "client" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- ALSA volume control
	awful.key({ modkey }, "F3", function()
		--awful.spawn('amixer -D pulse sset Master 5%+')
		awful.spawn("pulsemixer --change-volume +5")
	end, { description = "volume up", group = "hotkeys" }),
	awful.key({ modkey }, "F2", function()
		--awful.spawn('amixer -D pulse sset Master 5%-')
		awful.spawn("pulsemixer --change-volume -5")
	end, { description = "volume down", group = "hotkeys" }),
	awful.key({ modkey }, "F1", function()
		--awful.spawn('amixer -D pulse set Master 1+ toggle')
		awful.spawn("pulsemixer --toggle-mute")
	end, { description = "toggle mute", group = "hotkeys" }),
	-- Emoji Picker
	awful.key({ modkey }, ",", function()
		awful.util.spawn_with_shell("rofi -show emoji -modi emoji")
	end, { description = "rofi emoji", group = "rofi" }),
	-- rofi powermenu

	awful.key({ altkey, "Shift" }, "space", function()
		awful.util.spawn("/home/dhyey/.script/powermenu.sh")
	end, { description = "powemenu", group = "system" }),
	-- rofi locate

	awful.key({ modkey }, "space", function()
		awful.util.spawn("/home/dhyey/.script/rofi-fzf.sh")
	end, { description = "launch fzf rofi", group = "rofi" }),
	-- set wallpaper
	awful.key({ modkey, "Shift" }, "s", function()
		awful.util.spawn_with_shell("sxiv -t ~/Pictures/wallpaper")
	end, { description = "sxiv wallpaper picker", group = "system" }),
	-- gui file
	awful.key({ modkey }, "e", function()
		awful.util.spawn("ghostty -e yazi")
	end, { description = "lauch file manager", group = "program" }),
	-- gui file
	awful.key({ modkey, "Shift" }, "e", function()
		awful.util.spawn("pcmanfm-qt")
	end, { description = "lauch file manager", group = "program" }),

	awful.key({ modkey }, "w", function()
		awful.util.spawn("/home/dhyey/.script/web-search.sh")
	end, { description = "web search", group = "program" }),
	-- clipboard
	awful.key({ modkey }, "v", function()
		awful.util.spawn("/home/dhyey/.script/rofi-clip.sh")
	end, { description = "clipboard", group = "program" }),
	-- clipboard clear
	awful.key({ modkey, "Shift" }, "v", function()
		awful.util.spawn("greenclip clear")
	end, { description = "clipboard clear", group = "program" }),

	-- fullscreen screenshot
	awful.key({ modkey, "Shift" }, "p", function()
		--awful.util.spawn("/home/dhyey/scripts/scrotsave.sh") end,
		awful.util.spawn("/home/dhyey/.script/scrot-full.sh")
	end, { description = "fullscreen screenshot", group = "program" }),
	-- snip and screenshot
	awful.key({ modkey }, "s", function()
		awful.util.spawn("/home/dhyey/.script/scrot.sh")
	end, { description = "snip and screenshot", group = "program" }),
	-- colorpick
	awful.key({ modkey, "Shift" }, "c", function()
		awful.util.spawn_with_shell("xcolor | xclip -selection clipboard")
	end, { description = "colorpick", group = "program" }),

	-- browser
	awful.key({ modkey, "Shift" }, "Return", function()
		awful.util.spawn("helium-browser")
	end, { description = "browser", group = "program" }),
	--pulsemixer
	awful.key({ altkey, "Shift" }, "v", function()
		awful.util.spawn("pavucontrol")
	end, { description = "volume", group = "program" }),
	-- Show/hide wibox
	awful.key({ modkey }, "b", function()
		for s in screen do
			s.mywibox.visible = not s.mywibox.visible
			if s.mybottomwibox then
				s.mybottomwibox.visible = not s.mybottomwibox.visible
			end
		end
	end, { description = "toggle wibox", group = "awesome" }),

	-- chrome

	awful.key({ modkey, "Shift" }, "b", function()
		awful.util.spawn("google-chrome-stable")
	end, { description = "google chrome", group = "browser" }),
	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ altkey }, "space", function()
		awful.spawn("rofi -show drun")
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ altkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	awful.key({ modkey, altkey }, "l", function()
		awful.tag.incmwfact(0.03)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, altkey }, "h", function()
		awful.tag.incmwfact(-0.03)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, altkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, altkey }, "j", function()
		awful.client.incwfact(0.03)
	end, { description = "Decrease master height factor", group = "layout" }),
	awful.key({ modkey, altkey }, "k", function()
		awful.client.incwfact(-0.03)
	end, { description = "Increase master height factor", group = "layout" }),
	awful.key({ modkey, altkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ altkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ altkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ altkey, "Shift" }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Shift" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" })
)

clientkeys = gears.table.join(
	awful.key({ modkey, "Shift" }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ altkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key({ modkey }, "f", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	{
		rule = { class = "helium-browser" },
		properties = {
			screen = awful.screen.preferred,
			tag = awful.screen.focused().selected_tag,
			switch_to_tags = true, -- optional: switches to the tag automatically
		},
	},

	{
		rule = { class = "Zathura" },
		properties = {
			floating = false,
			maximized = false,
			titlebars_enabled = false,
		},
	},
	{
		rule = { class = "Ghostty" },
		properties = {
			border_width = 0,
			titlebars_enabled = false,
		},
	},

	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				--"Sxiv",
				"veracrypt",
				"mpv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
local function float_nmtui_terminal(c)
	if c.class == "Ghostty" and c.name and c.name:match("nmtui%-go") then
		c.floating = true
		c.ontop = true
		awful.placement.centered(c, { honor_workarea = true })
	end
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	float_nmtui_terminal(c)

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("property::name", function(c)
	float_nmtui_terminal(c)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
--client.connect_signal("request::titlebars", function(c)
---- buttons for the titlebar
--local buttons = gears.table.join(
--awful.button({ }, 1, function()
--c:emit_signal("request::activate", "titlebar", {raise = true})
--awful.mouse.client.move(c)
--end),
--awful.button({ }, 3, function()
--c:emit_signal("request::activate", "titlebar", {raise = true})
--awful.mouse.client.resize(c)
--end)
--)

--awful.titlebar(c) : setup {
--{ -- Left
--awful.titlebar.widget.iconwidget(c),
--buttons = buttons,
--layout  = wibox.layout.fixed.horizontal
--},
--{ -- Middle
--{ -- Title
--align  = "center",
--widget = awful.titlebar.widget.titlewidget(c)
--},
--buttons = buttons,
--layout  = wibox.layout.flex.horizontal
--},
--{ -- Right
--awful.titlebar.widget.floatingbutton (c),
--awful.titlebar.widget.maximizedbutton(c),
--awful.titlebar.widget.stickybutton   (c),
--awful.titlebar.widget.ontopbutton    (c),
--awful.titlebar.widget.closebutton    (c),
--layout = wibox.layout.fixed.horizontal()
--},
--layout = wibox.layout.align.horizontal
--}
--end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--c:emit_signal("request::activate", "mouse_enter", {raise = false})
--end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- Gaps
beautiful.useless_gap = 2
-- fix notification
--
--
beautiful.notification_icon_size = 80
_G.client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
_G.client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- Autostart
awful.spawn.with_shell("/home/dhyey/.config/awesome/awspawn")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("xrandr -s 1920x1200")
awful.spawn.with_shell("greenclip daemon&")
awful.spawn.with_shell("xfce4-power-manager")
awful.spawn.with_shell("nm-applet --indicator")
awful.spawn.with_shell("blueman-applet &")
awful.spawn.with_shell("volumeicon")
awful.spawn.with_shell("numlockx on")
awful.spawn.once("lxqt-policykit-agent")
awful.spawn.with_shell("/home/dhyey/.fehbg")
awful.spawn.with_shell("kill cbatticon && cbatticon")
awful.spawn.with_shell("helium-browser --no-startup-window --password-store=basic")
