"-------------------------------------------------
" => fzf-preview.vim
"-------------------------------------------------
if has_key(g:plugs, 'fzf-preview.vim')
    set viminfo='1000

    nmap <space>f [fzf-p]
    xmap <space>f [fzf-p]

    nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
    nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
    nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
    nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
    nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
    nnoremap <silent> [fzf-p]d     :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
    nnoremap          [fzf-p]D     :<C-u>CocCommand fzf-preview.DirectoryFiles<Space>
    nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
    nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
    nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
    nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
    nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
    nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
    xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
    nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
    nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
    nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
endif

"-------------------------------------------------
" => ack.vim
"-------------------------------------------------
if has_key(g:plugs, 'ack.vim')
    if executable('ag')
        let g:ackprg = 'ag --vimgrep'
    endif
    " I don't want to jump to the first result automatically.
    cnoreabbrev Ack Ack!
    nnoremap <Leader>a :Ack!<Space>
endif

"-------------------------------------------------
" => nerdtree
"-------------------------------------------------
if has_key(g:plugs, 'nerdtree')
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    map <Leader>F :NERDTreeToggle<CR>
endif
