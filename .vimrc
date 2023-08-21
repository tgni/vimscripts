" Vim config file.

" Global Settings: {{{
call pathogen#infect()              " use pathogen to manage plugins
syntax on                           " highlight syntax
filetype plugin indent on           " auto detect file type

set nocompatible                    " out of Vi compatible mode
set number                          " show line number
set numberwidth=3                   " minimal culumns for line numbers
set textwidth=0                     " do not wrap words (insert)
set nowrap                          " do not wrap words (view)
set showcmd                         " show (partial) command in status line
set ruler                           " line and column number of the cursor position
set wildmenu                        " enhanced command completion
set wildmode=list:longest,full      " command completion mode
set laststatus=2                    " always show the status line
set mouse=a                         " use mouse in all mode
"set foldenable                      " fold lines
"set foldmethod=marker               " fold as marker 
set noerrorbells                    " do not use error bell
set novisualbell                    " do not use visual bell
set t_vb=                           " do not use terminal bell

set wildignore=.svn,.git,*.swp,*.bak,*~,*.o,*.a,CVS
set autowrite                       " auto save before commands like :next and :make
set hidden                          " enable multiple modified buffers
set history=100                     " record recent used command history
set autoread                        " auto read file that has been changed on disk
set backspace=indent,eol,start      " backspace can delete everything
set completeopt=menuone,longest     " complete options (insert)
set pumheight=10                    " complete popup height
set scrolloff=5                     " minimal number of screen lines to keep beyond the cursor
set autoindent                      " automatically indent new line
set cinoptions=:0,l1,g0,t0,(0,(s    " C kind language indent options

set tabstop=8                       " number of spaces in a tab
set softtabstop=8                   " insert and delete space of <tab>
set shiftwidth=8                    " number of spaces for indent
"set expandtab                       " expand tabs into spaces
set incsearch                       " incremental search
set hlsearch                        " highlight search match
set ignorecase                      " do case insensitive matching
set smartcase                       " do not ignore if search pattern has CAPS
set nobackup                        " do not create backup file
set noswapfile                      " do not create swap file
set backupcopy=yes                  " overwrite the original file

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=gb2312,utf-8,gbk
set fileformat=unix

set background=dark
colorscheme vividchalk
"colorscheme desert 
"colorscheme desert blue darkblue default delk desert elflord evening morning
"koehler murphy pablo peachpuff ron shine slate torte zellner

"set tags+=tags;
"
" gui settings
if has("gui_running")
    set guioptions-=T " no toolbar
    set guioptions-=r " no right-hand scrollbar
    set guioptions-=R " no right-hand vertically scrollbar
    set guioptions-=l " no left-hand scrollbar
    set guioptions-=L " no left-hand vertically scrollbar
    "autocmd GUIEnter * simalt ~x " window width and height
    source $VIMRUNTIME/delmenu.vim " the original menubar has an error on win32, so
    source $VIMRUNTIME/menu.vim    " use this menubar
    language messages zh_CN.utf-8 " use chinese messages if has
endif

" Restore the last quit position when open file.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g'\"" |
    \ endif
"}}}

" Key Bindings: {{{
let mapleader = ","
let maplocalleader = "\\"

" map : -> <space>
map <Space> i 
""nnoremap
"move between windows
"nmap <C-w> <C-w>w
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
"nmap <C-l> <C-w><C-w>
nmap <C-l> <C-w>l
"
"nmap <C-T> <C-6>

"nnoremap <silent> <F3> :
" Don't use Ex mode, use Q for formatting
"map Q gq

"make Y consistent with C and D
nnoremap Y y$

" toggle highlight trailing whitespace
nmap <silent> <leader>l :set nolist!<CR>

" Ctrol-E to switch between 2 last buffers
"nmap <C-E> :b#<CR>

" ,e to fast finding files. just type beginning of a name and hit TAB
nmap <leader>e :e **/

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" ,n to get the next location (compilation errors, grep etc)
"nmap <leader>n :cn<CR>
"nmap <leader>p :cp<CR>

" Ctrl-N to disable search match highlight
nmap <silent> <C-N> :silent noh<CR>

" center display after searching
nnoremap n   nzz
nnoremap N   Nzz
nnoremap *   *zz
nnoremap #   #zz
nnoremap g*  g*zz
nnoremap g#  g#z

"--------------------------------------------------------------------------------
" Simulate Microsoft Windows hot-Key
"--------------------------------------------------------------------------------
"map windows quick click
vmap <C-y> "+y
vmap <C-x> "+d
nmap <C-p> "+p
vmap <C-p> "+p

"È«Ñ¡
nmap <C-a> ggvG$

"±£´æ
"imap <C-s> <Esc>:wa<cr>i<Right>
"nmap <C-s> :wa<cr>
nmap <C-s> :update<CR>

"we use ,q  instead of C-q to quit current file 
nnoremap <silent> <Leader>q :q<CR>



"--------------------------------------------------------------------------------
" Grep
"--------------------------------------------------------------------------------
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
set completeopt=longest,menu
nnoremap <silent> <F2> :Rgrep<CR>
set completeopt=longest,menu
"--------------------------------------------------------------------------------
"cscope
"--------------------------------------------------------------------------------
"
"--------------------------------------------------------------------------------
" mark setting
"--------------------------------------------------------------------------------

nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex 

"set number
"map <F12> :set number!<CR>
"for linux
"au GUIEnter * call MaximizeWindow()
"
"function! MaximizeWindow()
"    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
"endfunction

"}}}

" Plugin Settings: {{{
if has("win32") " win32 system
    let $HOME  = $VIM
    let $VIMFILES = $HOME . "/vimfiles"
else " unix
    let $HOME  = $HOME
    let $VIMFILES = $HOME . "/.vim"
endif

" mru
let MRU_Window_Height = 10
nmap <Leader>r :MRU<cr>

" taglist
let g:Tlist_WinWidth = 30
let g:Tlist_Use_Right_Window = 0
let g:Tlist_Auto_Update = 1
let g:Tlist_Process_File_Always = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Show_One_File = 1
let g:Tlist_Enable_Fold_Column = 0
let g:Tlist_Auto_Highlight_Tag = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1
nmap <Leader>t :TlistToggle<cr>

" nerdtree
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 30
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeQuitOnOpen = 0
nmap <Leader>f :NERDTreeToggle<CR>
"nmap <Leader>F :NERDTreeFind<CR>
"nmap <Leader>n :NERDTreeToggle<CR>
"nmap <Leader>N :NERDTreeFind<CR>

" snipMate
let g:snip_author   = "Tonggui Ni"
let g:snip_mail     = "tgni@triductor.com"
let g:snip_company  = "Triductor CO. Ltd"

" man.vim - view man page in VIM
source $VIMRUNTIME/ftplugin/man.vim
source $VIMRUNTIME/macros/matchit.vim

" cscope
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>si :cs find i <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>

"map <Leader>f :cs find f 
"map <Leader>g :cs find g 

" vimgdb.vim
if has("gdb")
	set asm=0
	let g:vimgdb_debug_file=""
	run macros/gdb_mappings.vim
endif

" ZoomWin
nmap <leader>zz <C-w>o

"map <F11>  :sp tags<CR>:%s/^\([^	:]*:\)\=\([^	]*\).*/syntax keyword Tag \2/<CR>:wq! tags.vim<CR>/^<CR><F12>
"map <F12>  :so tags.vim<CR>

" load the types.vim highlighting file, if it exists
"autocmd BufRead,BufNewFile *.[ch] let fname = expand('<afile>:p:h') . '/types.vim'
"autocmd BufRead,BufNewFile *.[ch] if filereadable(fname)
"autocmd BufRead,BufNewFile *.[ch]   exe 'so ' . fname
"autocmd BufRead,BufNewFile *.[ch] endif
autocmd BufEnter *.m compiler mlint

"-------------------------------------------------------------
"tabular settings 
"-------------------------------------------------------------
map <F4> :Tab /=<CR>

"matlab debugger
"-------------------------------------------------------------
"au FileType matlab map <buffer> <silent> <F5> :w<CR>:!matlab -nodesktop -nosplash -r "try, run(which('%')), end, quit" <CR><CR>
"au FileType matlab set foldmethod=syntax foldcolumn=2 foldlevel=33
