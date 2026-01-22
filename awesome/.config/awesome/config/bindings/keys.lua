local gears = require("gears")
local awful = require("awful")

local M = {}

function M.setup(opts)
	local modkey = opts.modkey
	local altkey = opts.altkey
	local terminal = opts.terminal

	local globalkeys = gears.table.join(
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
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
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
			awful.util.spawn("kitty yazi")
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
			awful.util.spawn("kitty wiremix -v output")
		end, { description = "volume", group = "program" }),
		-- wifi
		awful.key({ modkey, "Shift" }, "w", function()
			awful.util.spawn("kitty nmtui-go")
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
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(1)
		end, { description = "layout switch", group = "layout" }),

		awful.key({ modkey, "Shift" }, "n", function()
			local c = awful.client.restore()
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

	local clientkeys = gears.table.join(
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

	for i = 1, 9 do
		globalkeys = gears.table.join(
			globalkeys,
			awful.key({ modkey }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end, { description = "view tag #" .. i, group = "tag" }),
			awful.key({ modkey, "Control" }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end, { description = "toggle tag #" .. i, group = "tag" }),
			awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end, { description = "move focused client to tag #" .. i, group = "tag" }),
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

	root.keys(globalkeys)

	return {
		globalkeys = globalkeys,
		clientkeys = clientkeys,
	}
end

return M
