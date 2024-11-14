function ColorMy(color)
	color = color or "sonokai"
  vim.cmd [[
		let g:sonokai_transparent_background = 1
		let g:sonokai_menu_selection_background= 'blue'
  ]]
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none" })

end

ColorMy()
vim.cmd[[set number]]
