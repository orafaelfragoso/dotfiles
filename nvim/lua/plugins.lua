local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end
  }
}

packer.startup(function()
  -- plugins
  use 'wbthomason/packer.nvim'
  use 'Mofiqul/dracula.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'BurntSushi/ripgrep'
  use 'lewis6991/gitsigns.nvim'
  use 'windwp/nvim-autopairs'

  -- Tree with icons
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'

  -- Tree sitter
  use 'nvim-treesitter/nvim-treesitter'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'glepnir/lspsaga.nvim'

  -- CMP
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- Telescope
  use 'nvim-telescope/telescope.nvim'

  -- Bufferline
  use 'moll/vim-bbye'
  use 'akinsho/bufferline.nvim'

  -- Comments
  use 'numToStr/Comment.nvim'

  -- setup automatically
  if packer_bootstrap then
    require("packer").sync()
  end
end)

require('plugins.autopairs-config')
require('plugins.bufferline-config')
require('plugins.cmp-config')
require('plugins.comment-config')
require('plugins.gitsigns-config')
require('plugins.lualine-config')
require('plugins.lsp-config')
require('plugins.lspsaga-config')
require('plugins.nvimtree-config')
require('plugins.telescope-config')
require('plugins.treesitter-config')
