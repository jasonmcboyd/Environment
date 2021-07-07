" Don't try to be vi compatible
set nocompatible

" Blink cursor on error instead of beeping (grr)
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Show relative line numbers
set relativenumber

" Pick a leader key
let mapleader = " "

" Set timeout length for leader key to 500 ms
set timeoutlen=500

" Enable incremental search
set incsearch

" Return to normal mode from insert mode
inoremap <C-i> <Esc>
inoremap jj <Esc>

" Insert blank line above and return cursor to position
nnoremap <leader>O moO<Esc>`o
" Insert blank line below and return cursor to position
nnoremap <leader>o moo<Esc>`o

" Center search in middle of the screen
nnoremap n nzz
nnoremap N Nzz

" Change current line starting at first non-whitespace character and don't copy to the unnamed register
nnoremap <leader>cc ^"_c$

" Delete current line and don't copy it to the unnamed register
nnoremap <leader>dd "_dd

" x does not copy to unnamed register
nnoremap x "_x
" leader x does copy to unnamed register
nnoremap <leader>x x
