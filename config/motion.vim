"-------------------------------------------------
" => vim-sneak
"-------------------------------------------------
if has_key(g:plugs, 'vim-sneak')
    let g:sneak#label = 1

    map <Leader>s <Plug>Sneak_s
    map <Leader>S <Plug>Sneak_S

    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
endif

"-------------------------------------------------
" => incsearch.vim
"-------------------------------------------------
if has_key(g:plugs, 'incsearch.vim')
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
endif

"-------------------------------------------------
" => incsearch-fuzzy.vim
"-------------------------------------------------
if has_key(g:plugs, 'incsearch-fuzzy.vim')
    map z/ <Plug>(incsearch-fuzzyspell-/)
    map z? <Plug>(incsearch-fuzzyspell-?)
    map zg/ <Plug>(incsearch-fuzzyspell-stay)
endif

"-------------------------------------------------
" => incsearch-easymotion.vim
"-------------------------------------------------
if has_key(g:plugs, 'incsearch-easymotion.vim')
    function! s:config_easyfuzzymotion(...) abort
        return extend(copy({
                    \   'converters': [incsearch#config#fuzzy#converter()],
                    \   'modules': [incsearch#config#easymotion#module()],
                    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
                    \   'is_expr': 0,
                    \   'is_stay': 1
                    \ }), get(a:, 1, {}))
    endfunction

    noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
endif

"-------------------------------------------------
" => vim-easymotion
"-------------------------------------------------
if has_key(g:plugs, 'vim-easymotion')
    let g:EasyMotion_do_mapping = 0 " disable default key mappings

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
endif

"-------------------------------------------------
" => vim-easy-align
"-------------------------------------------------
if has_key(g:plugs, 'vim-easy-align')
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endif

"-------------------------------------------------
" => delimitMate
"-------------------------------------------------
if has_key(g:plugs, 'delimitMate')
    let delimitMate_expand_cr=1
    let delimitMate_expand_space=1
    let delimitMate_balance_matchpairs=1
endif

