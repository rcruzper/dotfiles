""""""""""""""""""""""""""""""
" Plugins                    "
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Colorscheme
Plug 'dracula/vim', { 'as': 'dracula' }

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

call plug#end()

