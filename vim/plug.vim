""""""""""""""""""""""""""""""
" Plugins                    "
""""""""""""""""""""""""""""""
call plug#begin()

" Colorscheme
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" Make commenting easier (gcc, gcap)
Plug 'tpope/vim-commentary'

" Trail whitespaces
Plug 'bronson/vim-trailing-whitespace'

" Fuzzy file opener
Plug 'ctrlpvim/ctrlp.vim'

" A tree explorer
Plug 'scrooloose/nerdtree'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'powerline/powerline-fonts'

" Syntax plugins
Plug 'glench/vim-jinja2-syntax', { 'for': 'jinja' }
Plug 'tpope/vim-git', { 'for': 'gitcommit' }

Plug 'tpope/vim-surround'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

