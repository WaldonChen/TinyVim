"     _____     _
"    /_  _/  __(_)___ ___
"     / / | / / / __ `__ \
"    / /| |/ / / / / / / /
"   /_/ |___/_/_/ /_/ /_/
"
"   Main Contributor: Waldon Chen <waldonchen at gmail.com>
"   Version: 1.0
"   Created: 2018-04-19
"   Last Modified: 2018-04-19
"
"   Sections:
"       -> 通用设置
"       -> 平台相关设置
"       -> 插件管理器
"       -> 用户界面配置
"       -> 颜色和字体
"       -> 缩进
"       -> 搜索
"       -> 折叠
"       -> 常用键映射
"       -> 插件配置
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tinyvim_user = "Waldon Chen"
let g:tinyvim_email = "waldonchen at gmail.com"
let g:tinyvim_github = "https://waldonchen.github.io"
let g:tinyvim_autocomplete = "NEO"  " or YCM
let g:tinyvim_fancy_font = 1
let g:tinyvim_expand_tab = 1
let g:tinyvim_default_indent = 4

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => 通用设置
"------------------------------------------------

set nocompatible " Get out of vi compatible mode
filetype plugin indent on " Enable filetype
let mapleader=',' " Change the mapleader
let maplocalleader='\' " Change the maplocalleader
set timeoutlen=500 " Time to wait for a command

" Source the vimrc file after saving it
autocmd BufWritePost $MYVIMRC source $MYVIMRC
" Fast edit the .vimrc file using ,x
nnoremap <Leader>x :tabedit $MYVIMRC<CR>

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
    let prefix='.vim'
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => 插件管理器
"------------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" -> 文件，代码搜索工具
"--------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'

" -> 自动补全
"--------------------------------------
if g:tinyvim_autocomplete == 'NEO'
    if has('lua')
        let g:tinyvim_completion_engine='neocomplete'
        Plug 'Shougo/neocomplete.vim' " Auto completion framework
    else
        let g:tinyvim_completion_engine='neocomplcache'
        Plug 'Shougo/neocomplcache.vim' " Auto completion framework
    endif
    Plug 'Shougo/neosnippet.vim' " Snippet engine
    Plug 'Shougo/neosnippet-snippets' " Snippets
else
    let g:tinyvim_completion_engine='YouCompleteMe'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' } "Auto completion framework
    Plug 'rdnetto/YCM-Generator'
    Plug 'honza/vim-snippets' " Snippets
    Plug 'sirver/ultisnips' " Snippet engine
endif

" -> 代码检测、对齐、格式化
"--------------------------------------
Plug 'w0rp/ale' " Asynchronous Lint Engine
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " Easy align
Plug 'Raimondi/delimitMate' " Closing of quotes
Plug 'tomtom/tcomment_vim' " Commenter
Plug 'tpope/vim-abolish' " Abolish
Plug 'tpope/vim-speeddating' " Speed dating
Plug 'tpope/vim-repeat' " Repeat
Plug 'terryma/vim-multiple-cursors' " Multiple cursors
Plug 'junegunn/vim-slash' " In-buffer search
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } " Undo tree
Plug 'tpope/vim-surround' " Surround
Plug 'AndrewRadev/splitjoin.vim' " Splitjoin
Plug 'sickill/vim-pasta' " Vim pasta
Plug 'wellle/targets.vim' " Text objects
Plug 'roman/golden-ratio' " Resize windows
Plug 'chrisbra/vim-diff-enhanced' " Create better diffs
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" -> 移动、挑转
"--------------------------------------
Plug 'justinmk/vim-sneak' " Jump to any location specified by two characters.
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar' " Tag bar

" ->  UI配置
Plug 'kristijanhusak/vim-hybrid-material' " Colorscheme hybrid material
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'

" -> 版本控制
Plug 'mhinz/vim-signify' " Git diff sign
Plug 'tpope/vim-git' " Synatax highlighting for git
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'gregsexton/gitv' " Gitk for vim

" -> 其它
Plug 'yianwillis/vimcdoc' " Chinese vim doc

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => 用户界面配置
"------------------------------------------------

" -> buffer line
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" -> status line
let g:airline_theme='bubblegum'
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline_powerline_fonts=1

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
colorscheme hybrid_reverse

" Set GUI font
if has('gui_running')
    if has('gui_gtk')
        set guifont=DejaVu\ Sans\ Mono\ 18
    else
        set guifont=DejaVu\ Sans\ Mono:h18
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

"-------------------------------------------------
" => 搜索
"-------------------------------------------------

set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set hlsearch " Highlight search terms
set incsearch " Find as you type search
set gdefault " turn on g flag

" Use sane regexes
nnoremap / /\v
vnoremap / /\v
cnoremap s/ s/\v
nnoremap ? ?\v
vnoremap ? ?\v
cnoremap s? s?\v

" Use ,Space to toggle the highlight search
nnoremap <Leader><Space> :set hlsearch!<CR>

"-------------------------------------------------
" => 折叠
"-------------------------------------------------

set foldlevelstart=0 " Start with all folds closed
set foldcolumn=1 " Set fold column

" Space to toggle and create folds.
nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : '\<Space>')<CR>
vnoremap <Space> zf

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => 插件配置
"------------------------------------------------

" -> fzf.vim
map <Leader>b :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" -> ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" I don't want to jump to the first result automatically.
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" -> ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

if has('unix') || has('macunix')
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
endif
if has('win32') || has('win64')
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
endif

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
" let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

" -> vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" -> delimitMate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1
let delimitMate_balance_matchpairs=1

" -> Tcomment
" Map \<Space> to commenting
function! IsWhiteLine()
    if (getline('.')=~'^$')
        exe 'TCommentBlock'
        normal! j
    else
        normal! A
        exe 'TCommentRight'
        normal! l
        normal! x
    endif
    startinsert!
endfunction
nnoremap <silent> <LocalLeader><Space> :call IsWhiteLine()<CR>

" -> Multiple cursors
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if g:tinyvim_completion_engine=='neocomplete'
        exe 'NeoCompleteLock'
    else
        exe 'NeoComplCacheLock'
    endif
endfunction
" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
    if g:tinyvim_completion_engine=='neocomplete'
        exe 'NeoCompleteUnlock'
    else
        exe 'NeoComplCacheUnlock'
    endif
endfunction

" -> vim-clang-format
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
            \ "IndentWidth" : g:tinyvim_default_indent,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11",
            \ "BreakBeforeBraces " : "Custom",
            \ "BraceWrapping" : {
            \       "AfterFunction" : "true"
            \ }}

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>)

" -> Undo tree
nnoremap <Leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1

" -> Goyo and limelight
nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" -> Neocomplete & Neocomplcache
if g:tinyvim_autocomplete=='NEO'
    " -> Neocomplete & Neocomplcache
    " Use Tab and S-Tab to select candidate
    inoremap <expr><Tab>  pumvisible() ? "\<C-N>" : "\<Tab>"
    inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
    if g:tinyvim_completion_engine=='neocomplete'
        let g:neocomplete#enable_at_startup=1
        let g:neocomplete#data_directory=$HOME . '/.vim/cache/neocomplete'
        let g:neocomplete#enable_auto_delimiter=1
        " Use <C-E> to close popup
        inoremap <expr><C-E> neocomplete#cancel_popup()
        inoremap <expr><CR> delimitMate#WithinEmptyPair() ?
                    \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
                    \ pumvisible() ? neocomplete#close_popup() : "\<CR>"
    else
        let g:neocomplcache_enable_at_startup=1
        let g:neocomplcache_temporary_dir=$HOME . '/.vim/cache/neocomplcache'
        let g:neocomplcache_enable_auto_delimiter=1
        let g:neocomplcache_enable_fuzzy_completion=1
        " Use <C-E> to close popup
        inoremap <expr><C-E> neocomplcache#cancel_popup()
        inoremap <expr><CR> delimitMate#WithinEmptyPair() ?
                    \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
                    \ pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    endif
    " Setting for specific language
    if has('lua')
        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns={}
        endif
        let g:neocomplete#force_omni_input_patterns.python=
                    \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
    else
        if !exists('g:neocomplcache_force_omni_patterns')
            let g:neocomplcache_force_omni_patterns={}
        endif
        let g:neocomplcache_force_omni_patterns.python=
                    \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
    endif
    autocmd FileType python setlocal omnifunc=jedi#completions
    let g:jedi#completions_enabled=0
    let g:jedi#auto_vim_configuration=0
    let g:jedi#smart_auto_mappings=0
    let g:jedi#use_tabs_not_buffers=1
    let g:tmuxcomplete#trigger=''
    " -> Neosnippet
    " Set information for snippets
    let g:neosnippet#enable_snipmate_compatibility=1
    " Use <C-K> to expand or jump snippets in insert mode
    imap <C-K> <Plug>(neosnippet_expand_or_jump)
    " Use <C-K> to replace TARGET within snippets in visual mode
    xmap <C-K> <Plug>(neosnippet_start_unite_snippet_target)
    " For snippet_complete marker
    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif
else
    " -> YouCompleteMe
    let g:ycm_confirm_extra_conf = 0

    " -> UltiSnips
    let g:UltiSnipsExpandTrigger="<C-K>"
    let g:UltiSnipsJumpForwardTrigger="<Tab>"
    let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
endif

" Setting info for snips
let g:snips_author=g:tinyvim_user
let g:snips_email=g:tinyvim_email
let g:snips_github=g:tinyvim_github

" -> vim-sneak
let g:sneak#label = 1

map <Leader>s <Plug>Sneak_s
map <Leader>S <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" -> incsearch.vim & incsearch-fuzzy.vim && incsearch-easymotion.vim

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" -> vim-easymotion

" <Leader>f{char} to move to {char}
" map  <Leader>f <Plug>(easymotion-bd-f)
" nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
