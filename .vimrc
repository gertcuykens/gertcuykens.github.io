set nocompatible
set hidden
set laststatus=0
set showtabline=0
set ttimeoutlen=0
set mouse=a
set noshowmode
set incsearch
set hlsearch
set encoding=utf-8
set clipboard=unnamed
set backspace=indent,eol,start
set autochdir
set rtp+=~/.fzf
let $FZF_DEFAULT_OPTS = '--info=inline'
let g:fzf_layout = {'window': 'enew'}
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:loaded_netrwPlugin = 1
filetype plugin on
colorscheme codedark
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function FzfDir(bufnr)
"   if getftype(bufname(a:bufnr)) == 'dir'
"     execute 'cd ' . bufname(a:bufnr) 
"     execute 'bd' . a:bufnr
"     execute 'Files'
"   endif
" endfunction

" autocmd BufEnter * call FzfDir(bufnr('%'))

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" au FilterWritePre * if &diff | colorscheme xyz | endif
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" let loaded_netrw = 1
" let loaded_netrwPlugin = 1
" let g:fzf_layout = { 'tmux': '-p90%,60%' }
" set showcmd
" set autoindent?
" let g:mapleader = '\\'
" let g:maplocalleader = '\\'
" <C-V> <S-I>
" nnoremap <SPACE> <Nop>
" vnoremap <Leader>c "+y
" call fzf#vim#files(bufname(a:bufnr))
" printf '\e]0;Title\e\\'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :marks
" ma
" 'a

" ma-z local
" mA-Z global

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :tags :tnext :tprev :tfirst :tlast
" ^] go to
" ^t go back to tag

" !ctags -R .
" !ctags --list-languages

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :jumps
" ^o out older
" ^i in new

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :changes
" g,
" g;

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :set omnifunc?
" ^x ^o

" ^d complete options

" ^p complete previous txt
" ^n complete next txt

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :set spelllang?
" :set spelllang=en
" :set spell | nospell
" ]s | [s
" z=

" :echo &runtimepath
" :echo globpath(&runtimepath, "spell/*.spl")
" :mkspell ~/.vim/spell en

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :helptags $VIMRUNTIME/doc
" :help tag

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" _ last used variable
" $ env variable
" @a-z registers
" g: s: b: w: t: scope
" function! MyFunc()
"   let myvar = 1
" endfunction

" let &number = 1 
" set number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ^o normal mode
" v V ^v visual mode

" u undo
" ^r redo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:netrw_silent = 1
" let g:netrw_banner = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function PbCopy() abort
"   let yanked_text = @@
"   if yanked_text =~ '\S'
"     let escaped_text = shellescape(yanked_text, 1)
"     execute 'silent !echo -n ' . escaped_text . ' | nc -q 0 localhost 2000' | redraw!
"   endif
" endfunction

" command PbCopy call PbCopy()
" autocmd TextYankPost * call PbCopy()

