call dein#add('tpope/vim-markdown', { 'rev': 'f9f845f28f4da33a7655accb22f4ad21f7d9fb66', 'on_ft': ['markdown', 'pandoc'] })

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript']

function! s:sed_inplace(cmd, file) abort
  if has('macunix')
    execute 'silent !sed -i '''' ' . shellescape(a:cmd) . ' ' . shellescape(a:file)
  else
    execute 'silent !sed -i ' . shellescape(a:cmd) . ' ' . shellescape(a:file)
  endif
endfunction

function! s:open_browser(path) abort
  if has('macunix')
    execute 'silent !open -a "Firefox" ' . shellescape(a:path) . ' >/dev/null 2>&1 &'
  else
    execute 'silent !firefox ' . shellescape(a:path) . ' >/dev/null 2>&1 &'
  endif
endfunction

function! PMarkdown() abort
  execute 'silent !cp ' . shellescape($HOME . '/.config/gh.css') . ' /tmp/gh.css'
  execute 'silent !pandoc ' . shellescape(expand('%:p')) . ' -s -c gh.css -o /tmp/_pmd.html'

  call s:sed_inplace('/<colgroup>/,/<\/colgroup>/d', '/tmp/_pmd.html')
  call s:sed_inplace('s/<style>/<style>pre{background-color:#f6f8fa}/g', '/tmp/_pmd.html')

  call s:open_browser('/tmp/_pmd.html')
  redraw!
endfunction

function! FPreview() abort
  call s:open_browser(expand('%:p'))
  redraw!
endfunction

augroup filetype_pandoc
  autocmd!
  autocmd FileType pandoc,markdown noremap <buffer> <F5> <cmd>call PMarkdown()<CR>
augroup END
