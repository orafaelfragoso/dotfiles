local opt = vim.opt -- to set options
local g = vim.g -- a table to access global variables
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local indentation = 2
local HOME = os.getenv("HOME")

-- Essentials
g.mapleader = " "
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/bin/python3"
g.bulitin_lsp = true

-- Behaviors
opt.belloff     = "all" -- NO BELLS!
opt.completeopt = { "menu", "menuone", "noselect" } -- ins-completion how vsnip likes it
opt.swapfile    = false -- no swap files
opt.backup      = false -- no backup files
opt.writebackup = false -- no backup
opt.undodir     = HOME .. '/.vim/tmp/undo//' -- undo files
opt.backupdir   = HOME .. '/.vim/tmp/backup//' -- backups
opt.directory   = '/.vim/tmp/swap//' -- swap files
opt.inccommand  = "nosplit" -- preview %s commands live as I type
opt.undofile    = true -- keep track of my 'undo's between sessions
opt.grepprg     = "rg --vimgrep --smart-case --no-heading" -- search with rg
opt.grepformat  = "%f:%l:%c:%m" -- filename:line number:column number:error message
opt.mouse       = "nv" -- use mouse in normal, visual modes

-- Indentation
opt.autoindent  = true -- continue indentation to new line
opt.smartindent = true -- add extra indent when it makes sense
opt.smarttab    = true -- <Tab> at the start of a line behaves as expected
opt.expandtab   = true -- <Tab> inserts spaces
opt.shiftwidth  = indentation -- >>, << shift line by 4 spaces
opt.tabstop     = indentation -- <Tab> appears as 4 spaces
opt.softtabstop = indentation -- <Tab> behaves as 4 spaces when editing

-- Colors
opt.termguicolors = true
opt.background    = "dark"

-- Look and feel
opt.number         = true -- numbers?
opt.relativenumber = true -- no numbers?
opt.signcolumn     = "auto" -- show the sign column if necessary
opt.cursorline     = true -- don't highlight current line
opt.list           = true -- show list chars
opt.listchars      = {
  -- these list chars
  tab = "»·",
  nbsp = "␣",
  extends = "…",
  precedes = "…",
  trail = "·",
}
opt.scrolloff      = 10 -- padding between cursor and top/bottom of window
opt.foldlevel      = 0 -- allow folding the whole way down
opt.foldlevelstart = 99 -- open files with all folds open
opt.splitright     = true -- prefer vsplitting to the right
opt.splitbelow     = true -- prefer splitting below
opt.wrap           = false -- don't wrap my text
opt.textwidth      = 120 -- wrap here for comments by default
opt.cursorline     = true -- hightlight line cursor is on
opt.laststatus     = 3 -- single global statusline
opt.showmatch      = true -- show matching brackets
opt.synmaxcol      = 300 -- stop syntax highlight after x lines for performance

-- Searching
opt.wildmenu   = true -- tab complete on command line
opt.ignorecase = true -- case insensitive search...
opt.smartcase  = true -- unless I use caps
opt.hlsearch   = true -- highlight matching text
opt.incsearch  = true -- update results while I type

-- Commands
cmd("colorscheme dracula")
cmd("let base16colorspace=256")
--cmd("highlight! default link GitSignsDeleteLn GitSignsDelete") -- render deleted lines in preview window correctly
