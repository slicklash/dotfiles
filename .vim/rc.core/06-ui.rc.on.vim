vim9script

if !has('termguicolors')
  set t_Co=256
else
  # TODO: fix hex colors
  # set termguicolors
endif

colorscheme aloneinthedark

set noshowmode                              # don't show mode
set showcmd                                 # in visual mode show size of selection
set showmatch matchtime=2                   # show matching parentheses/brackets
set laststatus=2                            # always show statusline

# set completeopt=menu,menuone,popup,noselect
set completeopt=menu,menuone,noselect
set completeitemalign=abbr,kind,menu
set pumheight=12

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

  set guioptions-=T                        # no GUI tool bar
  set guioptions-=m                        # no menu
  set guioptions-=r                        # hide scrollbars
  set guioptions-=l
  set guioptions-=L
  &guioptions = substitute(&guioptions, "t", "", "g")
  if has('vim_starting') && has('win32')
    # start maximized
    autocmd GUIEnter * simalt ~X
  endif
endif

# custom GetTabline
def g:GetTabline(): string
  var line = ''
  var current = tabpagenr()

  for i in range(tabpagenr('$'))
    var tab = i + 1
    var selected = tab == current
    var winnr = tabpagewinnr(tab)
    var buflist = tabpagebuflist(tab)
    var bufnr = buflist[winnr - 1]
    var name = bufname(bufnr)

    line ..= '%' .. tab .. 'T'

    if !selected && tab > 1 && current + 1 != tab
      line ..= '%#TabSeparator#|'
    elseif tab > 1
      line ..= ' '
    endif

    line ..= selected ? '%#TabLineSel#' : '%#TabLine#'

    var label = tab .. ': ' .. (name !=# '' ? fnamemodify(name, ':t') : 'No Name')
    if getbufvar(bufnr, '&modified')
      label ..= '*'
    endif

    line ..= ' ' .. label .. ' '
  endfor

  line ..= '%#TabLineFill#'
  return line
enddef

set tabline=%!GetTabline()
