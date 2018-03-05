""""""""""""""""""""""""""""""
" Plugins                    "
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Colorscheme
Plug 'chriskempson/base16-vim'

" Fancy statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

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

