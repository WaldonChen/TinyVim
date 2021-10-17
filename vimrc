"=======================================================================
"     _____     _
"    /_  _/  __(_)___ ___
"     / / | / / / __ `__ \
"    / /| |/ / / / / / / /
"   /_/ |___/_/_/ /_/ /_/
"
"   Main Contributor: Waldon Chen <waldonchen at gmail.com>
"   Version: 1.2
"   Created: 2018-04-19
"   Last Modified: 2020-12-28
"=======================================================================

let g:tinyvim_user = "Waldon Chen"
let g:tinyvim_email = "waldonchen at gmail.com"
let g:tinyvim_github = "https://waldonchen.github.io"
let g:tinyvim_fancy_font = 1
let g:tinyvim_expand_tab = 1
let g:tinyvim_default_indent = 4
let g:tinyvim_powerline_fonts = 1

"------------------------------------------------
" => 通用设置
"------------------------------------------------
set nocompatible " Get out of vi compatible mode
filetype plugin indent on " Enable filetype
let mapleader=',' " Change the mapleader
let maplocalleader='\' " Change the maplocalleader
set timeoutlen=500 " Time to wait for a command

" Source the vimrc file after saving it
" autocmd BufWritePost $MYVIMRC source $MYVIMRC
" Fast edit the .vimrc file using ,x
" nnoremap <Leader>x :tabedit $MYVIMRC<CR>

set autoread " Set autoread when a file is changed outside
set autowrite " Write on make/shell commands
set hidden " Turn on hidden"

set history=1000 " Increase the lines of history
set modeline " Turn on modeline
set encoding=utf-8 " Set utf-8 encoding
set completeopt+=longest " Optimize auto complete
set completeopt-=preview " Optimize auto complete

set undofile " Set undo

" Set directories
function! InitializeDirectories()
    let parent=$HOME
    let prefix='.cache/TinyVim'
    let dir_list={
                \ 'backup': 'backupdir',
                \ 'view': 'viewdir',
                \ 'swap': 'directory',
                \ 'undo': 'undodir',
                \ 'cache': '',
                \ 'session': ''}
    for [dirname, settingname] in items(dir_list)
        let directory=parent.'/'.prefix.'/'.dirname.'/'
        if !isdirectory(directory)
            if exists('*mkdir')
                let dir = substitute(directory, "/$", "", "")
                call mkdir(dir, 'p')
            else
                echo 'Warning: Unable to create directory: '.directory
            endif
        endif
        if settingname!=''
            exe 'set '.settingname.'='.directory
        endif
    endfor
endfunction
call InitializeDirectories()

autocmd BufWinLeave *.* silent! mkview " Make Vim save view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview " Make Vim load view (state) (folds, cursor, etc)

"-------------------------------------------------
" => 平台相关设置
"-------------------------------------------------

" On Windows, also use .vim instead of vimfiles
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

set viewoptions+=slash,unix " Better Unix/Windows compatibility
set viewoptions-=options " in case of mapping change

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"-------------------------------------------------
" => 插件
"-------------------------------------------------
call plug#begin('$HOME/.vim/plugged')

" -> 文件查找
"--------------------------------------
Plug 'junegunn/fzf', {'dir': '$HOME/.vim/fzf', 'do': './install --all'}      " fuzzy search in a dir
" Plug 'junegunn/fzf.vim'                                                    " fuzzy search in a dir
Plug 'yuki-ycino/fzf-preview.vim'
" Plug 'preservim/nerdtree'

" -> 自动补全
"--------------------------------------
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}         " completion, snippets etc
Plug 'antoinemadec/coc-fzf'
Plug 'dense-analysis/ale'                                                  " asynchronous lint engine
Plug 'honza/vim-snippets'                                                  " snippets

" -> 移动、搜索、挑转
"--------------------------------------
Plug 'justinmk/vim-sneak'                                                  " jump to any location specified by two characters.
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'                                                  " surround
Plug 'Raimondi/delimitMate'                                                " closing of quotes
" Plug 'majutsushi/tagbar'

" -> 代码检测、对齐、格式化
"--------------------------------------
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" Plug 'terryma/vim-multiple-cursors'
Plug  'chrisbra/vim-diff-enhanced'
Plug  'rhysd/vim-clang-format'
" Plug 'kana/vim-operator-user'
" Plug 'Shougo/vimproc.vim', {'build' : 'make'}

" -> 版本控制
"--------------------------------------
Plug 'tpope/vim-fugitive'                                                  " Git wrapper
Plug 'airblade/vim-gitgutter'                                              " Git diff sign
" Plug 'mhinz/vim-signify' " Git diff sign
Plug 'tpope/vim-git'                                                       " Synatax highlighting for git
Plug 'gregsexton/gitv'                                                     " Gitk for vim

" ->  UI配置
"--------------------------------------
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'                                                " status line
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'RRethy/vim-illuminate'

call plug#end()

" -> 插件配置
"--------------------------------------
for plugin in ['finder', 'completion', 'motion', 'ui']
    let s:plugin_config = $HOME . '/.vim/config/' . plugin .'.vim'
    if filereadable(s:plugin_config)
        execute 'source ' . s:plugin_config
    endif
endfor

"------------------------------------------------
" => 用户界面配置
"------------------------------------------------

" -> status line
set laststatus=2

" Only have cursorline in current window and in normal window
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline
autocmd InsertEnter * set nocursorline
autocmd InsertLeave * set cursorline
set wildmenu " Show list instead of just completing
set wildmode=list:longest,full " Use powerful wildmenu
set shortmess=at " Avoids hit enter
set showcmd " Show cmd

set backspace=indent,eol,start " Make backspaces delete sensibly
set whichwrap+=h,l,<,>,[,] " Backspace and cursor keys wrap to
set virtualedit=block,onemore " Allow for cursor beyond last character
set scrolljump=5 " Lines to scroll when cursor leaves screen
set scrolloff=3 " Minimum lines to keep above and below cursor
set sidescroll=1 " Minimal number of columns to scroll horizontally
set sidescrolloff=10 " Minimal number of screen columns to keep away from cursor

set showmatch " Show matching brackets/parenthesis
set matchtime=2 " Decrease the time to blink

set number " Show line numbers
" Toggle relativenumber
nnoremap <Leader>n :set relativenumber!<CR>

set formatoptions+=rnlmM " Optimize format options
set wrap " Set wrap
set textwidth=80 " Change text width
if g:tinyvim_fancy_font
    set list " Show these tabs and spaces and so on
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮ " Change listchars
    set linebreak " Wrap long lines at a blank
    set showbreak=↪  " Change wrap line break
    set fillchars=diff:⣿,vert:│ " Change fillchars
    augroup trailing " Only show trailing whitespace when not in insert mode
        autocmd!
        autocmd InsertEnter * :set listchars-=trail:⌴
        autocmd InsertLeave * :set listchars+=trail:⌴
    augroup END
endif

"------------------------------------------------
" => 颜色和字体
"------------------------------------------------

syntax on " Enable syntax
set background=dark " Set background
if !has('gui_running')
    set t_Co=256 " Use 256 colors
endif
colorscheme gruvbox

" Set GUI font
if has('gui_running')
    if has('gui_gtk')
        set guifont=MesloLGS\ NF\ Regular\ 14
    else
        set guifont=MesloLGS\ NF\ Regular:h14
    endif
endif

"------------------------------------------------
" => 缩进
"------------------------------------------------

set autoindent " Preserve current indent on new lines
set cindent " set C style indent
let &expandtab=g:tinyvim_expand_tab " Convert all tabs typed to spaces
let &softtabstop=g:tinyvim_default_indent " Indentation levels every four columns
let &shiftwidth=g:tinyvim_default_indent " Indent/outdent by four columns
set shiftround " Indent/outdent to nearest tabstop
augroup filetype_makefile
    autocmd!
    autocmd FileType Makefile set noexpandtab
augroup END
" @see help cinoptions-values
set cino=l1,t0,(0,W4,E-s

"-------------------------------------------------
" => 折叠
"-------------------------------------------------

set foldlevelstart=0 " Start with all folds closed
set foldcolumn=1 " Set fold column

" Space to toggle and create folds.
" nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : '\<Space>')<CR>
" vnoremap <Space> zf

" Set foldtext
function! MyFoldText()
    let line=getline(v:foldstart)
    let nucolwidth=&foldcolumn+&number*&numberwidth
    let windowwidth=winwidth(0)-nucolwidth-3
    let foldedlinecount=v:foldend-v:foldstart+1
    let onetab=strpart('          ', 0, &tabstop)
    let line=substitute(line, '\t', onetab, 'g')
    let line=strpart(line, 0, windowwidth-2-len(foldedlinecount))
    let fillcharcount=windowwidth-len(line)-len(foldedlinecount)
    return line.'…'.repeat(' ',fillcharcount).foldedlinecount.'L'.' '
endfunction
set foldtext=MyFoldText()

"-------------------------------------------------
" => 常用键映射
"-------------------------------------------------

" Make j and k work the way you expect
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Navigation between windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Repeat last substitution, including flags, with &.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Select entire buffer
nnoremap vaa ggvGg_

" Strip all trailing whitespace in the current file
nnoremap <Leader>q :%s/\s\+$//<CR>:let @/=''<CR>

" Modify all the indents
nnoremap \= gg=G

" See the differences between the current buffer and the file it was loaded from
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
            \ | diffthis | wincmd p | diffthis

"-------------------------------------------------
" => misc
"-------------------------------------------------

" terminal
if has('terminal')
    command! T  call term_start(&shell, {"term_kill": "term", "term_finish": "close", "curwin": 1})
    command! TS call term_start(&shell, {"term_kill": "term", "term_finish": "close"})
    command! TV call term_start(&shell, {"term_kill": "term", "term_finish": "close", "vertical": 1})
    command! TT tab call term_start(&shell, {"term_kill": "term", "term_finish": "close"})
elseif has('nvim')
    command! T terminal
    command! TS split | terminal
    command! TV vsplit | terminal
    command! TT tabe | terminal
endif

" open scratch buffer
command! -bar -nargs=? Scratch <args>new | setlocal buftype=nofile bufhidden=hide noswapfile
