if InitStep() == 0
    call dein#add('itchyny/lightline.vim')
    finish
endif

scriptencoding utf-8

" custom status line
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
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
                \  &ft == 'unite' ? unite#get_status_string() :
                \  &ft == 'nerdtree' ? 'NERDTree':
                \  &ft == 'vimshell' ? vimshell#get_status_string() :
                \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
    if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#statusline")
        let l:g = fugitive#statusline()
        if !strlen(l:g)
            return ''
        endif
        let l:g = substitute(tolower(l:g), '\v(git|[\[\]\)])', '', 'g')
        let l:n = stridx(l:g, '(')
        if l:n > 0
            let l:r = strpart(l:g, 0, l:n)
            return 'git:' . strpart(l:g, l:n + 1) . l:r
        else
            return 'git:' . strpart(l:g, l:n + 1)
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
                \ fname == 'ControlP' ? 'CtrlP' :
                \ fname == '__Gundo__' ? 'Gundo' :
                \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                \ fname =~ 'NERD_tree' ? '' :
                \ &ft == 'unite' ? 'Unite' :
                \ &ft == 'vimfiler' ? 'VimFiler' :
                \ &ft == 'vimshell' ? 'VimShell' : bn
    "\ winwidth(0) > 60 ? bn . ' ' . lightline#mode() : ''
endfunction

function! MyLintInfo() abort
    if !exists('*ale#Lint')
        return ''
    endif

    let l:counts = ale#statusline#Count(bufnr(''))

    if l:counts.total == 0
        return ''
    endif

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return printf(
    \   '✗ %d ∆ %d',
    \   all_errors,
    \   all_non_errors,
    \)
endfunction
