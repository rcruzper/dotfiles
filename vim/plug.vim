""""""""""""""""""""""""""""""
" Plugins                    "
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Colorscheme
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'

" Fancy statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Make commenting easier
Plug 'tpope/vim-commentary'

" Trail whitespaces
Plug 'bronson/vim-trailing-whitespace'

" Fuzzy file opener
Plug 'ctrlpvim/ctrlp.vim'

" A tree explorer
Plug 'scrooloose/nerdtree'

" Syntax plugins
Plug 'glench/vim-jinja2-syntax', { 'for': 'jinja' }
Plug 'tpope/vim-git', { 'for': 'gitcommit' }
call plug#end()
