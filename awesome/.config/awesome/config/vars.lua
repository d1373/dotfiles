local M = {}

M.terminal = "kitty"
M.editor = os.getenv("EDITOR") or "nvim"
M.editor_cmd = M.terminal .. " -e " .. M.editor

M.modkey = "Mod4"
M.altkey = "Mod1"

return M
