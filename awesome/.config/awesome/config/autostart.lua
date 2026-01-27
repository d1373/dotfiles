local awful = require("awful")

local M = {}

function M.setup()
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
	awful.spawn.with_shell("flatpak run org.localsend.localsend_app --hidden")
end

return M
