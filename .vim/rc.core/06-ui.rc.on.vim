if !has('termguicolors')
  set t_Co=256
" else
  " set termguicolors
endif

colorscheme aloneinthedark

set noshowmode                              " don't show mode
set showcmd                                 " in visual mode show size of selection
set showmatch matchtime=2                   " show matching parentheses/brackets
set laststatus=2                            " always show statusline
" set completeopt-=preview                    " disable snippet/complete preview window
set completeopt=menu,menuone,noselect

set cursorline
if !has('nvim')
  set cursorlineopt=screenline
endif
set cursorline

augroup cursorline_control
  autocmd!
  autocmd WinEnter,BufEnter * setlocal cursorline
  autocmd WinLeave,BufLeave * setlocal nocursorline
augroup END

if has('gui_running')
  if has('unix')
    set guifont=JetBrainsMono\ Nerd\ Font\ Mono\ Light\ 12
  elseif has('win32')
    set guifont=Consolas:h10
  endif

  set guioptions-=T                        " no GUI tool bar
  set guioptions-=m                        " no menu
  set guioptions-=r                        " hide scrollbars
  set guioptions-=l
  set guioptions-=L
  let &guioptions = substitute(&guioptions, "t", "", "g")
  if has('vim_starting') && has('win32')
    " start maximized
    autocmd GUIEnter * simalt ~X
  endif
endif

" custom Tabline
function! Tabline()
  let l:line = ''
  let l:current = tabpagenr()

  for l:i in range(tabpagenr('$'))
    let l:tab = l:i + 1
    let l:selected = l:tab == l:current
    let l:winnr = tabpagewinnr(l:tab)
    let l:buflist = tabpagebuflist(l:tab)
    let l:bufnr = l:buflist[l:winnr - 1]
    let l:name = bufname(l:bufnr)

    let l:line .= '%' . l:tab . 'T'

    if !l:selected && l:tab > 1 && l:current + 1 != l:tab
      let l:line .= '%#TabSeparator#|'
    elseif l:tab > 1
      let l:line .= ' '
    endif

    let l:line .= l:selected ? '%#TabLineSel#' : '%#TabLine#'

    let l:label = l:tab . ': ' . (l:name !=# '' ? fnamemodify(l:name, ':t') : 'No Name')
    if getbufvar(l:bufnr, '&modified')
      let l:label .= '*'
    endif

    let l:line .= ' ' . l:label . ' '
  endfor

  let l:line .= '%#TabLineFill#'
  return l:line
endfunction

set tabline=%!Tabline()
