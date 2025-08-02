local notify_status_ok, notify = pcall(require, "notify")
if notify_status_ok then
	notify.setup({
		background_colour = "#1e1e2e",
	})
end
