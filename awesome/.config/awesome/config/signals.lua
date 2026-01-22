local awful = require("awful")
local beautiful = require("beautiful")

local M = {}

function M.setup()
	local function float_nmtui_terminal(c)
		if c.class == "Ghostty" and c.name and c.name:match("nmtui%-go") then
			c.floating = true
			c.ontop = true
			awful.placement.centered(c, { honor_workarea = true })
		end
	end

	client.connect_signal("manage", function(c)
		if not awesome.startup then
			awful.client.setslave(c)
		end

		float_nmtui_terminal(c)

		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_offscreen(c)
		end
	end)

	client.connect_signal("property::name", function(c)
		float_nmtui_terminal(c)
	end)

	-- Enable sloppy focus, so that focus follows mouse.
	--client.connect_signal("mouse::enter", function(c)
	--c:emit_signal("request::activate", "mouse_enter", {raise = false})
	--end)

	_G.client.connect_signal("focus", function(c)
		c.border_color = beautiful.border_focus
	end)
	_G.client.connect_signal("unfocus", function(c)
		c.border_color = beautiful.border_normal
	end)
end

return M
