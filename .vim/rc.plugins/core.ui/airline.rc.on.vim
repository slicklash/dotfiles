scriptencoding utf-8

call dein#add('vim-airline/vim-airline', { 'rev': 'd842cfb9dd38ccf1e0385989d405b79b4f4bca8e' })

let g:airline_theme = 'dark'
let g:airline_theme_patch_func = 'MyAirlineThemePatch'
let g:airline_left_alt_sep = '|'
let g:airline_right_alt_sep = '|'
let g:airline_inactive_collapse = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]

function! s:airline_color(fg, bg) abort
  return [a:fg[0], a:bg[0], a:fg[1], a:bg[1]]
endfunction

function! s:airline_active(mode_color, fixed_color) abort
  return airline#themes#generate_color_map(
        \ a:mode_color,
        \ a:fixed_color,
        \ a:mode_color,
        \ a:mode_color,
        \ a:fixed_color,
        \ a:fixed_color,
        \ )
endfunction

function! MyAirlineThemePatch(palette) abort
  let l:fg = ['#949494', 246]
  let l:bg = ['#3a3a3a', 237]
  let l:normal = s:airline_color(l:fg, l:bg)
  let l:normal_alt = s:airline_color(l:bg, l:fg)

  let a:palette.normal = s:airline_active(l:normal, l:normal_alt)
  let a:palette.insert = s:airline_active(s:airline_color(l:fg, ['#015faf', 25]), l:normal_alt)
  let a:palette.replace = s:airline_active(s:airline_color(l:bg, ['#af5f5f', 131]), l:normal_alt)
  let a:palette.visual = s:airline_active(s:airline_color(l:bg, ['#ac5e03', 130]), l:normal_alt)
  let a:palette.inactive = s:airline_active(l:normal, l:normal)
  let a:palette.terminal = copy(a:palette.insert)
  let a:palette.commandline = copy(a:palette.normal)

  for l:mode in [
        \ 'normal_modified',
        \ 'insert_modified',
        \ 'insert_paste',
        \ 'replace_modified',
        \ 'visual_modified',
        \ 'inactive_modified',
        \ ]
    if has_key(a:palette, l:mode)
      call remove(a:palette, l:mode)
    endif
  endfor

  let a:palette.accents = {
        \ 'red': ['#bf616a', '', 167, ''],
        \ 'green': ['#a3be8c', '', 107, ''],
        \ 'blue': ['#80a1c1', '', 110, ''],
        \ 'yellow': ['#ebcb8b', '', 227, ''],
        \ 'orange': ['#d79a5b', '', 215, ''],
        \ 'purple': ['#b48dad', '', 175, ''],
        \ }

  call airline#themes#patch(a:palette)
endfunction

augroup MyAirline
  autocmd!
  autocmd User AirlineAfterInit call MyAirlineInit()
augroup END

function! MyAirlineInit() abort
  for l:part in [
        \ ['my_mode', 'MyMode'],
        \ ['my_filename', 'MyFilename'],
        \ ['my_fugitive', 'MyFugitive'],
        \ ['my_lint_info', 'MyAirlineLintInfo'],
        \ ['my_fileformat', 'MyFileformat'],
        \ ['my_fileencoding', 'MyFileencoding'],
        \ ['my_filetype', 'MyFiletype'],
        \ ['my_shiftwidth', 'MyShiftWidth'],
        \ ]
    call airline#parts#define_function(l:part[0], l:part[1])
  endfor

  let g:airline_section_a = airline#section#create_left(['my_mode', 'paste'])
  let g:airline_section_b = airline#section#create_left(['my_filename', 'my_fugitive'])
  let g:airline_section_c = airline#section#create(['my_lint_info'])
  let g:airline_section_x = airline#section#create_right([
        \ 'my_fileformat',
        \ 'my_fileencoding',
        \ 'my_filetype',
        \ 'my_shiftwidth',
        \ ])
  let g:airline_section_y = '%p%%'
  let g:airline_section_z = '%l:%c'
endfunction

function! MyAirlineLintInfo() abort
  return get(w:, 'airline_active', 1) ? MyLintInfo() : ''
endfunction

if exists('*airline#parts#define_function')
  call MyAirlineInit()
endif

function! MyModified()
  return &ft =~ 'help\|fern\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|fern\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'fern\|gundo' && exists("*fugitive#statusline")
    let g = fugitive#statusline()
    if !strlen(g)
      return ''
    endif
    let g = substitute(tolower(g), '\v(git|[\[\]\)])', '', 'g')
    let n = stridx(g, '(')
    if n > 0
      let r = strpart(g, 0, n)
      return 'git:' . strpart(g, n + 1) . r
    else
      return 'git:' . strpart(g, n + 1)
    endif
  endif
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat ==# 'dos' ? '🚨dos' : &fileformat) : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyShiftWidth()
  return winwidth(0) > 70 ? 'sw: ' .&shiftwidth : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  let bn = bufnr('%')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ &ft == 'fern' ? 'fern' : bn
endfunction

function! MyLintInfo() abort
  if !exists('*ale#Env')
    return ''
  endif

  if ale#engine#IsCheckingBuffer(bufnr(''))
    return 'checking...'
  endif

  let counts = ale#statusline#Count(bufnr(''))
  if counts.total == 0
    return ''
  endif

  let all_errors = counts.error + counts.style_error
  let all_non_errors = counts.total - all_errors

  return printf(
        \   '✗ %d ∆ %d',
        \   all_errors,
        \   all_non_errors,
        \)
endfunction
