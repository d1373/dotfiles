-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } })
  use 'ThePrimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use({ 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x' })
  use({ 'neovim/nvim-lspconfig' })
  use({ 'hrsh7th/nvim-cmp' })
  use({ 'hrsh7th/cmp-nvim-lsp' })
  use({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    run = "make install_jsregexp"
  })
  use 'nvim-pack/nvim-spectre'
  use 'preservim/nerdcommenter'
  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-surround'
  use 'dikiaap/minimalist'
  use { 'sainnhe/sonokai' }
  use {
    'nvim-lualine/lualine.nvim',
  }
end)
