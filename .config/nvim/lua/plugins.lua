local plugins = { }

function plugins.ensure_packer()
	local fn = vim.fn
	local install_path = fn.stdpath('data') ..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end


function plugins.startup()
	return require('packer').startup(function(use)
		use 'wbthomason/packer.nvim'
		-- My plugins here


		-- nvim-tree with devicons
		use {
			'nvim-tree/nvim-tree.lua',
			requires = { 'nvim-tree/nvim-web-devicons', },
		}

		use {
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim"
			},
			config = function()
				-- local capabilities = vim.lsp.protocol.make_client_capabilities()
				-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

				require('mason').setup()
				local mason_lspconfig = require 'mason-lspconfig'
				mason_lspconfig.setup {
					ensure_installed = { "pylsp" }
				}
				require("lspconfig").pylsp.setup {}
			end
		}

		-- treesitter for better syntax highlighting, folding, etc
		use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
					local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
					ts_update()
			end,
			config = function()
				require('nvim-treesitter.configs').setup({
					ensure_installed = { "lua", "vim", "python"},
					autoinstall = false,
				})
			end
		}
		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if plugins.ensure_packer() then
			require('packer').sync()
		end
	end)
end

return plugins.startup()
