" Main configuration
set nocompatible
set ruler
set hidden
syntax on
set background=dark
colorscheme solarized
set number
set tabstop=4
set shiftwidth=4
set guifont=Monaco:h18

" Remove the scrollbar and the toolbar at the top
:set guioptions-=T
:set guioptions-=r

" Identation
set smartindent
set autoindent

" Autocompletion
set wildmode=list:longest

" Enable folding
set foldenable

" Enable the movement with mouse cursor
:set mouse=a


filetype plugin on
filetype indent on

" Highlighted search
set hlsearch

" Some keymaps for speed up the production
nmap <space> :






" Source the vimrc after saving it
if has("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif
