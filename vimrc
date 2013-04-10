" Vundle stuff
set nocompatible

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Gtihub.com
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'w0ng/vim-hybrid'
" Let's give it a try and see what is it...
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'PotatoesMaster/i3-vim-syntax'

let g:notes_directory = '~/.vim/notes'
let g:notes_suffix = '.txt'

if !(&term =~ '^linux' || &term =~ '^screen')
    " Set 256-color terminal
    set t_Co=256
    Bundle 'Lokaltog/vim-powerline'
endif

set fcs=vert:│,fold:- " solid instead of broken line for vert splits
set mouse=a " enable mouse in all modes


" plugins

" Set the suffix of the [notes] file
let g:Powerline_stl_path_style = 'short'

" Start all macros with ','

let maplocalleader=','

" Open .vimrc in a new tab
map <LocalLeader>ce :tabedit ~/.vimrc<cr>
" Source .vimrc file
map <LocalLeader>cs :source ~/.vimrc<cr>

" Shoud chek that carefully
nmap <LocalLeader>p i<S-MiddleMouse><ESC>
imap <S-Insert> <S-MiddleMouse>
cmap <S-Insert> <S-MiddleMouse>

" Switch hlsearch off
map <LocalLeader>nh :nohlsearch<cr>

set pastetoggle=<F2>
let g:solarized_termcolors=256
let g:solarized_contrast="high"


set laststatus=2                    " always show the status line
function! CurDir()
    let curdir = substitute(getcwd(), '/home/tema/', "~/", "g")
    return curdir
endfunction

"set background=light
if (&term =~ '^linux' || &term =~'^screen')
    colorscheme elflord
    "Format the statusline
    set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c
    "set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    "              | | | | |  |   |      |  |     |    |
    "              | | | | |  |   |      |  |     |    + current
    "              | | | | |  |   |      |  |     |       column
    "              | | | | |  |   |      |  |     +-- current line
    "              | | | | |  |   |      |  +-- current % into file
    "              | | | | |  |   |      +-- current syntax in
    "              | | | | |  |   |          square brackets
    "              | | | | |  |   +-- current fileformat
    "              | | | | |  +-- number of lines
    "              | | | | +-- preview flag in square brackets
    "              | | | +-- help flag in square brackets
    "              | | +-- readonly flag in square brackets
    "              | +-- rodified flag in square brackets
    "              +-- full path to file in the buffer
else
    colorscheme solarized
endif

if has('gui_running')
    let g:Powerline_symbols = 'unicode'
    set background=light
    set guifont=DejaVu\ Sans\ Mono\ 10
else
    set background=dark
endif


" Showing red border at column 77 and 78
hi ColorColumn ctermbg=124
imap <F8><F8> <ESC>:call SetCC()<CR><INSERT><RIGHT>
nmap <F8><F8> <ESC>:call SetCC()<CR>
function! SetCC()
    let _cc = getwinvar(0, '&cc')
    if _cc == 0
        call setwinvar(0, '&cc', '78')
    else
        call setwinvar(0, '&cc', '')
    endif
endfunction


" Showing cross cursor
hi CursorColumn term=NONE cterm=NONE ctermbg=240
hi CursorLine term=NONE cterm=NONE ctermbg=240
imap <F8><F9> <ESC>:set cuc! cul!<CR><INSERT><RIGHT>
nmap <F8><F9> <ESC>:set cuc! cul!<CR>

" Showing tab and tailing space
set lcs=tab:»-,trail:► "&raquo; and U+22C5, U+9674=&loz;
hi SpecialKey ctermfg=239
"hi NonText ctermfg=234
imap <F8><F7> <ESC>:set list!<CR><INSERT><RIGHT>
nmap <F8><F7> <ESC>:set list!<CR>

" Spell check
map <F7> <ESC>:setlocal spell! spelllang=en_gb<CR>


" Delete spaces
imap <LocalLeader>ds <ESC>:%s/\s\+$//e<CR>
nmap <LocalLeader>ds <ESC>:%s/\s\+$//e<CR>

" Interface
syn on
set autoread
set number
set expandtab sw=4 sts=4

filetype on

if has ("autocmd")
    " Settings for python
    autocmd BufRead *.py setlocal tabstop=4
    autocmd BufRead *.py setlocal shiftwidth=4
    autocmd BufRead *.py setlocal smarttab
    autocmd BufRead *.py setlocal expandtab
    autocmd BufRead *.py setlocal softtabstop=4
    autocmd BufRead *.py setlocal autoindent
    autocmd BufRead *.py setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

    " Markdown syntax and settings
    autocmd BufEnter *.md,*.markdown
            \ setlocal filetype=markdown spell tw=80 wrap

    " SaC syntax
    autocmd BufEnter *.sac
            \ setlocal filetype=sac

    " Use tabs and show them in makefil
    autocmd BufEnter ?akefile*
            \ setlocal noet ts=8 sw=8 nocindent list

    " *.def is a C file (GCC)
    autocmd BufEnter *.def
            \ setlocal syntax=c ts=4 sw=4 sts=4

    " Settings for TeX
    autocmd BufEnter *.tex
            \ setlocal et nocp ts=4 sw=4 sts=4 tw=80 wrap spell

    " Cut the crap in C files
    autocmd BufWritePre *.\(c\|h\|def\) :%s/\s\+$//e
    
    " A syntaxfile for i3 config
    autocmd BufEnter *i3/config
            \ setlocal filetype=i3

    " Oh yeah, hilight down the CRAP in sac2c source code
    autocmd BufEnter */sac2c/*.c  setlocal expandtab
    autocmd BufEnter */sac2c/*.c  syn keyword sacBullshit DBUG_ENTER
    autocmd BufEnter */sac2c/*.c  syn keyword sacBullshit DBUG_RETURN
    autocmd BufEnter */sac2c/*.c  hi def link sacBullshit Comment
endif

if &term == "tmux" || &term =~ "^xterm" || &term =~ "^(u)?rxvt" || &term =~ '^screen'
  set title
endif

set cinoptions+=c1,C1
set comments=sl:/*,m:\ ,e:*/
let g:load_doxygen_syntax=1
let c_no_curly_error = 1
let c_gnu=1
let tex_no_error=1
" That should hopefully fix lack of highlight when you start
" with empty *.tex file.
let g:tex_flavor='latex'
