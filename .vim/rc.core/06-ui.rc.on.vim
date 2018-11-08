
set t_Co=256                                " number of colors

colorscheme aloneinthedark

set noshowmode                              " don't show mode
set showcmd                                 " in visual mode show size of selection
set showfulltag                             " show usage help
set showmatch matchtime=2                   " show matching parentheses/brackets
set laststatus=2                            " always show statusline

set cursorline
augroup win_switch
    autocmd!
    autocmd WinLeave * if &ft!='vimfiler' | setlocal nocursorline | endif
    autocmd WinEnter * setlocal cursorline
augroup END

if has("gui_running")
    if has("unix")
        set guifont=DejaVu\ Sans\ Mono\ 9
    elseif IsWindows()
        set guifont=Consolas:h10
    endif

    set guioptions-=T                        " no GUI tool bar
    set guioptions-=m                        " no menu
    set guioptions-=r                        " hide scrollbars
    set guioptions-=l
    set guioptions-=L
    let &guioptions = substitute(&guioptions, "t", "", "g")
    if has('vim_starting')
        if IsWindows()
            " start maximized
            autocmd GUIEnter * simalt ~X
        endif
    endif
endif

" custom Tabline
function! Tabline()
    let s = ''
    let current = tabpagenr()

    for i in range(tabpagenr('$'))
        let tab = i + 1
        let selected = tab == current
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)

        let s .= '%' . tab . 'T'
        if !selected && tab > 1 && current + 1 != tab
            let s .= '%#TabSeparator#' . '|'
        elseif tab > 1
            let s .= ' '
        endif
        let s .= (selected ? '%#TabLineSel#' : '%#TabLine#')
        let name = '' . tab . ': ' . (bufname != '' ? fnamemodify(bufname, ':t') : 'No Name')
        if getbufvar(bufnr, "&mod")
            let name .= '*'
        endif
        let s .= ' ' . name . ' '
    endfor

    let s .= '%#TabLineFill#'
    return s
endfunction

set tabline=%!Tabline()
