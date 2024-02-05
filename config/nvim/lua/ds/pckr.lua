local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add {
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { { 'nvim-lua/plenary.nvim' } }
  },
  'nvim-lua/plenary.nvim',
  'nvim-pack/nvim-spectre',
  'preservim/nerdcommenter',
  'jiangmiao/auto-pairs',
  'github/copilot.vim',
  { 'mg979/vim-visual-multi',
    branch = 'master',
  },
  { 'sainnhe/sonokai',
    config = function()
      vim.cmd [[
		let g:sonokai_transparent_background = 1
		let g:sonokai_style= 'espresso'
		let g:sonokai_menu_selection_background= 'blue'
		colorscheme sonokai

		]]
    end },
  'airblade/vim-gitgutter',
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',

    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
  },
  'tpope/vim-surround',
  "tpope/vim-fugitive",
  "mbbill/undotree",
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  },

};
