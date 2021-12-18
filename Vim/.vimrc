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

" Enable highlight search
set hlsearch

" Return to normal mode from insert mode
inoremap <C-i> <Esc>
inoremap jj <Esc>
inoremap JJ <Esc>

" Turn off search highlight
nnoremap <esc> :noh<cr><esc>

" Insert blank line above and return cursor to position
nnoremap <leader>O moO<Esc>`o
" Insert blank line below and return cursor to position
nnoremap <leader>o moo<Esc>`o

" Center search in middle of the screen
nnoremap n nzz
nnoremap N Nzz

" Change current line starting at first non-whitespace character and don't copy to the unnamed register
nnoremap cc ^"_c$

" Standard cc command
nnoremap <leader>cc cc

" Change in and change around do not copy to the unnamed register
nnoremap <leader>ciw "_ciw
nnoremap <leader>caw "_caw

" Delete the current line and copy to the unnamed register
nnoremap dd "_dd

" Standard dd command
nnoremap <leader>dd dd

" x does not copy to unnamed register
nnoremap x "_x

" leader x does copy to unnamed register
nnoremap <leader>x x
