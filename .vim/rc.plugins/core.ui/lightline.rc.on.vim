scriptencoding utf-8

call dein#add('itchyny/lightline.vim', { 'rev': 'e358557e1a9f9fc860416c8eb2e34c0404078155' })

let g:lightline = {
      \ 'enable': {
      \    'tabline': 0
      \},
      \ 'colorscheme': 'aloneinthedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'filename', 'fugitive' ], ['lint_info'] ],
      \   'right': [ ['lineinfo'], ['percent'], [ 'fileformat', 'fileencoding', 'filetype', 'shiftwidth' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ], [ 'filename', 'fugitive' ] ],
      \   'right': [ ['lineinfo'], ['percent'], [ 'fileformat', 'fileencoding', 'filetype', 'shiftwidth' ] ]
      \ },
      \ 'mode_map': {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'VL',
      \ 'c' : 'N',
      \ "\<C-v>": 'V-BLOCK',
      \ 's' : 'SELECT',
      \ 'S' : 'S-LINE',
      \ "\<C-s>": 'S-BLOCK',
      \ '?': ' ' },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'shiftwidth': 'MyShiftWidth',
      \   'mode': 'MyMode',
      \   'lint_info': 'MyLintInfo',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! MyModified()
  return &ft =~ 'help\|defx\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|defx\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'defx\|gundo' && exists("*fugitive#statusline")
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
  return winwidth(0) > 70 ? &fileformat : ''
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
        \ &ft == 'defx' ? 'defx' :
        \ &ft == 'vimshell' ? 'VimShell' : bn
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
