local home_path = vim.fn.expand('$HOME')

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.encoding = 'utf-8'
vim.opt.syntax = 'on'
vim.opt.nu = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ruler = true
vim.opt.showcmd = true
table.insert(vim.opt.shortmess, 'c')
vim.opt.shell = zsh
vim.opt.hidden = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.autoindent = true
vim.opt.smartindent = true
table.insert(vim.opt.mouse, 'a')
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.dir = home_path .. "/.tmp/nvim/swap"
vim.opt.undodir = home_path .. "/.tmp/nvim/undo"
vim.opt.backupdir = home_path .. "/.tmp/nvim/backup"
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.backup = true
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2,min:40,sbr'
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.smartcase = true
vim.opt.errorbells = false
vim.opt.visualbell = false

vim.g.transparent_background = true

vim.opt.termguicolors = false
vim.opt.background = 'dark'

-- on macOS some site directories aren't included in the lua package path.
-- This code constructs the nvim paths for lua plugins at runtime.
-- vim.opt.runtimepath tells nvim where to look for runtime code
-- package.path stores paths for lua to check at runtime for lua code
-- 	to execute.
-- 	http://lua-users.org/wiki/PackagePath
-- BEGIN PACKAGE PATH MANIPULATION --

-- initialize/populate base variables
local data_path = vim.fn.stdpath('data')
local config_path = vim.fn.stdpath('config')
local baseSubPath = '/site/pack/?/opt/?/'
local pPaths = {}

-- supply paths to the nvim runtime
table.insert(vim.opt.runtimepath, data_path .. '/site/pack/*/opt/*')
table.insert(vim.opt.runtimepath, config_path .. '/site/pack/*/opt/*')

-- build a table with all the permutations we need to ensure are in the
-- package.path
for _,ppath in ipairs({'', 'lua/', '?.nvim/'}) do
	for _,spath in ipairs({data_path, config_path}) do
		table.insert(pPaths, spath .. baseSubPath .. ppath .. '/init.lua')
		table.insert(pPaths, spath .. baseSubPath .. ppath .. '/?.lua')
	end
end

-- append the constructed list of paths to package.path
package.path = package.path .. ';' .. table.concat(pPaths, ';')
-- END PACKAGE PATH MANIPULATION --


-- load our 'plugins.lua' file, which specifies what and how to load all of
-- the nvim plugins specified therein.
require('plugins')
