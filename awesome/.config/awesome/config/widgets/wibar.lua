local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local base = require("wibox.widget.base")
local beautiful = require("beautiful")

local M = {}

function M.setup(opts)
	local modkey = opts.modkey

	local mytextclock = wibox.widget.textclock(" %d - %H:%M")

	local bar_bg = beautiful.bar_bg or "#101013"
	local bar_accent = beautiful.bar_accent or beautiful.fg_focus
	local bar_fg = beautiful.bar_fg or "#ffffff"
	local bar_red = beautiful.red or beautiful.fg_urgent or "#ff5a5a"
	local bar_green = beautiful.green or "#6dd98c"

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

	local function make_icon_widget_color(glyph, color)
		local widget = wibox.widget.textbox()
		widget.font = icon_font
		widget.valign = "center"
		widget.align = "center"
		widget:set_markup("<span foreground='" .. color .. "'>" .. glyph .. "</span>")
		return widget
	end

	local volume_icon = make_icon_widget("󰕾")
	local volume_widget = wibox.container.place(volume_icon, "center", "center")
	local volume_level = 0
	local volume_bar = base.make_widget()
	volume_bar.fit = function(_, _, _)
		return 70, 6
	end
	volume_bar.draw = function(_, _, cr, width, height)
		local line_y = math.floor(height / 2)
		cr:set_source(gears.color(bar_accent))
		cr:set_line_width(2)
		cr:move_to(0, line_y)
		cr:line_to(width, line_y)
		cr:stroke()

		local t = math.max(0, math.min(volume_level / 100, 1))
		local dot_x = t * width
		cr:set_source(gears.color(bar_fg))
		cr:arc(dot_x, height / 2, 3, 0, math.pi * 2)
		cr:fill()
	end

	local function change_volume(delta)
		local sign = delta > 0 and "+" or ""
		awful.spawn("pulsemixer --change-volume " .. sign .. delta)
	end

	local volume_scroll_buttons = gears.table.join(
		awful.button({}, 4, function()
			change_volume(5)
		end),
		awful.button({}, 5, function()
			change_volume(-5)
		end)
	)

	volume_widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.spawn("kitty wiremix -v output")
		end),
		volume_scroll_buttons
	))

	local clock_widget = wibox.container.background(mytextclock)
	clock_widget.fg = bar_fg

	local volume_text = wibox.widget.textbox()
	volume_text.valign = "center"
	volume_text.font = beautiful.font
	volume_text:set_markup("<span foreground='" .. bar_fg .. "'>--%</span>")
	volume_text:buttons(volume_scroll_buttons)
	volume_bar:buttons(volume_scroll_buttons)

	awful.widget.watch("pulsemixer --get-volume", 1, function(widget, stdout)
		local level = tonumber(stdout:match("(%d+)"))
		if level then
			widget:set_markup("<span foreground='" .. bar_fg .. "'>" .. level .. "%</span>")
			volume_level = level
			volume_bar:emit_signal("widget::redraw_needed")
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

	local power_icon = make_icon_widget_color("󰐥", bar_red)
	local power_widget = wibox.container.place(power_icon, "center", "center")
	power_widget:buttons(gears.table.join(awful.button({}, 1, function()
		awful.spawn.with_shell("/home/dhyey/.script/powermenu.sh")
	end)))

	local wifi_glyph = "󰖩"
	local wifi_icon = make_icon_widget_color(wifi_glyph, bar_fg)
	local wifi_widget = wibox.container.place(wifi_icon, "center", "center")
	wifi_widget:buttons(gears.table.join(awful.button({}, 1, function()
		awful.spawn("kitty nmtui-go")
	end)))

	awful.widget.watch("nmcli -t -f DEVICE,TYPE,STATE dev", 5, function(widget, stdout)
		local connected = false
		for line in stdout:gmatch("[^\n]+") do
			local _, dev_type, state = line:match("([^:]+):([^:]+):([^:]+)")
			if dev_type == "wifi" and state == "connected" then
				connected = true
				break
			end
		end
		local color = connected and bar_green or bar_fg
		widget:set_markup("<span foreground='" .. color .. "'>" .. wifi_glyph .. "</span>")
	end, wifi_icon)

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
		if beautiful.wallpaper then
			local wallpaper = beautiful.wallpaper
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
	end

	screen.connect_signal("property::geometry", set_wallpaper)

	awful.screen.connect_for_each_screen(function(s)
		awful.tag({ "", "", "", "", "", "󰭹", "", "", "󰓇" }, s, awful.layout.layouts[1])

		s.mypromptbox = awful.widget.prompt()
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

		s.mytaglist = awful.widget.taglist({
			screen = s,
			filter = awful.widget.taglist.filter.all,
			buttons = taglist_buttons,
			layout = {
				spacing = 15,
				layout = wibox.layout.fixed.horizontal,
			},
		})

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

		s.mywibox = awful.wibar({ position = "top", screen = s, bg = bar_bg, height = 30 })

		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				s.mytaglist,
				s.myfocus,
			},
			wibox.widget.textbox(""),
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				systray,
				make_separator(),
				battery_widget,
				power_widget,
				wifi_widget,
				volume_widget,
				volume_bar,
				volume_text,
				make_separator(),
				clock_widget,
				s.mylayoutbox,
			},
		})
	end)
end

return M
