local function bootstrap_pckr() local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

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

require('pckr').add{
	{'preservim/nerdtree';
	requires = {
	'ryanoasis/vim-devicons';
	'tiagofumo/vim-nerdtree-syntax-highlight';
	};};
	{
	'nvim-telescope/telescope.nvim', tag = '0.1.5',
  	requires = { {'nvim-lua/plenary.nvim'} }
	};
	'preservim/nerdcommenter';
	'jiangmiao/auto-pairs';

	{'d1373/my_gruvbox';
	config = function()
		  vim.cmd[[
		  au ColorScheme * hi Normal ctermbg=none guibg=none
		  colorscheme gruvbox]]
	  end};
	{
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',

	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  	   };
  	};
	"tpope/vim-fugitive";
	"mbbill/undotree";
	{"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"};
	'vim-airline/vim-airline';
	'vim-airline/vim-airline-themes';

};
