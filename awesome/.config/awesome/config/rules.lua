local awful = require("awful")
local beautiful = require("beautiful")

local M = {}

function M.setup(opts)
	local clientkeys = opts.clientkeys
	local clientbuttons = opts.clientbuttons

	awful.rules.rules = {
		{
			rule = { class = "helium-browser" },
			properties = {
				screen = awful.screen.preferred,
				tag = awful.screen.focused().selected_tag,
				switch_to_tags = true,
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

		{
			rule_any = {
				instance = {
					"DTA",
					"copyq",
					"pinentry",
				},
				class = {
					"Arandr",
					"Blueman-manager",
					"Gpick",
					"Kruler",
					"MessageWin",
					--"Sxiv",
					"veracrypt",
					"Tor Browser",
					"Wpa_gui",
					"veromix",
					"xtightvncviewer",
				},
				name = {
					"Event Tester",
				},
				role = {
					"AlarmWindow",
					"ConfigManager",
					"pop-up",
				},
			},
			properties = { floating = true },
		},

		{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

		-- { rule = { class = "Firefox" },
		--   properties = { screen = 1, tag = "2" } },
	}
end

return M
