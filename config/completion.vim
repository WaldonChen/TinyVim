"-------------------------------------------------
" => coc.nvim
"-------------------------------------------------
if has_key(g:plugs, 'coc.nvim')
    let g:coc_data_home = '~/.vim/coc'

    " TextEdit might fail if hidden is not set
    " set hidden

    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Give more space for displaying messages
    " set cmdheight=2

    " Having longer updatetime leads to noticeable delays
    " and poor user experience.
    " set updatetime=300
    let g:cursorhold_updatetime = 100

    " Don't pass messages to |ins-completion-menu|
    set shortmess+=c

    set signcolumn=auto

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `[d` and `]d` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [d <Plug>(coc-diagnostic-prev)
    nmap <silent> ]d <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> <leader>gd <Plug>(coc-definition)
    nmap <silent> <leader>gy <Plug>(coc-type-definition)
    nmap <silent> <leader>gi <Plug>(coc-implementation)
    nmap <silent> <leader>gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'H '.expand('<cword>')
        elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
        else
            execute '!' . &keywordprg . " " . expand('<cword>')
        endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>fm  <Plug>(coc-format-selected)
    nmap <leader>fm  <Plug>(coc-format-selected)

    augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    " NeoVim-only mapping for visual mode scroll
    " Useful on signatureHelp after jump placeholder of snippet expansion
    if has('nvim')
        vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
        vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
    endif

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings for CoCList
    if has_key(g:plugs, 'coc-fzf')
        " Show all diagnostics.
        nnoremap <silent><nowait> <space><space>  :<C-u>CocFzfList<CR>
        nnoremap <silent><nowait> <space>a  :<C-u>CocFzfList diagnostics<CR>
        " Manage extensions.
        nnoremap <silent><nowait> <space>e  :<C-u>CocFzfList extensions<CR>
        " Show commands.
        nnoremap <silent><nowait> <space>c  :<C-u>CocFzfList commands<CR>
        " Find symbol of current document.
        nnoremap <silent><nowait> <space>o  :<C-u>CocFzfList outline<CR>
        " Search workspace symbols.
        nnoremap <silent><nowait> <space>s  :<C-u>CocFzfList -I symbols<CR>
        " Do default action for next item.
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent><nowait> <space>p  :<C-u>CocFzfListResume<CR>
    else
        " Show all diagnostics.
        nnoremap <silent><nowait> <space><space>  :<C-u>CocList<CR>
        nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<CR>
        " Manage extensions.
        nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<CR>
        " Show commands.
        nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<CR>
        " Find symbol of current document.
        nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<CR>
        " Search workspace symbols.
        nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<CR>
        " Do default action for next item.
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
    endif

    "-------------------------------------------------
    " global extensions
    "-------------------------------------------------
    let g:coc_global_extensions = [
                \ 'coc-git',
                \ 'coc-cmake', 
                \ 'coc-fzf-preview',
                \ 'coc-highlight',
                \ 'coc-json',
                \ 'coc-pyright',
                \ 'coc-snippets',
                \ 'coc-tabnine'
                \ ]

    " -> coc-git
    nmap <silent> [g <Plug>(coc-git-prevchunk)
    nmap <silent> ]g <Plug>(coc-git-nextchunk)
    nmap <silent> <leader>cs <Plug>(coc-git-chunkinfo)
    nmap <silent> <leader>cc <Plug>(coc-git-commit)
    omap <silent> ig <Plug>(coc-git-chunk-inner)
    xmap <silent> ig <Plug>(coc-git-chunk-inner)
    omap <silent> ag <Plug>(coc-git-chunk-outer)
    xmap <silent> ag <Plug>(coc-git-chunk-outer)

    " -> coc-snippets
    " Use <C-l> for trigger snippet expand.
    imap <C-l> <Plug>(coc-snippets-expand)

    " Use <C-j> for select text for visual placeholder of snippet.
    vmap <C-j> <Plug>(coc-snippets-select)

    " Use <C-j> for jump to next placeholder, it's default of coc.nvim
    let g:coc_snippet_next = '<c-j>'

    " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
    let g:coc_snippet_prev = '<c-k>'

    " Use <C-j> for both expand and jump (make expand higher priority.)
    imap <C-j> <Plug>(coc-snippets-expand-jump)

    " Use <leader>x for convert visual selected code to snippet
    xmap <leader>x  <Plug>(coc-convert-snippet)

    inoremap <silent><expr> <TAB>
                \ pumvisible() ? coc#_select_confirm() :
                \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    let g:coc_snippet_next = '<tab>'
endif

"-------------------------------------------------
" => coc-fzf
"-------------------------------------------------
if has_key(g:plugs, 'coc-fzf')
    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <space><space>  :<C-u>CocFzfList<CR>
    nnoremap <silent><nowait> <space>a  :<C-u>CocFzfList diagnostics<CR>
    " Manage extensions.
    nnoremap <silent><nowait> <space>e  :<C-u>CocFzfList extensions<CR>
    " Show commands.
    nnoremap <silent><nowait> <space>c  :<C-u>CocFzfList commands<CR>
    " Find symbol of current document.
    nnoremap <silent><nowait> <space>o  :<C-u>CocFzfList outline<CR>
    " Search workspace symbols.
    nnoremap <silent><nowait> <space>s  :<C-u>CocFzfList -I symbols<CR>
    " Do default action for next item.
    nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <space>p  :<C-u>CocFzfListResume<CR>
endif

"-------------------------------------------------
" => ale
"-------------------------------------------------
if has_key(g:plugs, 'ale')
    let g:ale_c_ccls_init_options = {
    \   'cache': {
    \       'directory': '/tmp/ccls'
    \   }
    \ }
    let g:ale_cpp_ccls_init_options = {
    \   'cache': {
    \       'directory': '/tmp/ccls'
    \   },
    \   'clang': {
    \       'extraArgs': [
    \           '-isystem/usr/local/include'
    \       ]
    \   }
    \ }
endif
