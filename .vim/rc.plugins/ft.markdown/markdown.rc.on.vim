if InitStep() == 0
  call dein#add('tpope/vim-markdown', { 'rev': 'feadbc81e27f277187c29957ec6114f1e95f2162', 'on_ft': ['markdown'] })
  finish
endif

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript']

function! PMarkdown()
  execute 'silent !cp /home/slicklash/.config/gh.css /tmp/gh.css'
  execute 'silent !pandoc ' . expand('%:p') . ' -s -c gh.css -o /tmp/_pmd.html'
  execute 'silent !firefox /tmp/_pmd.html > /dev/null 2>&1 &'
  redraw!
endfunction

function! FPreview()
  execute 'silent !firefox ' . expand('%:p') . '> /dev/null 2>&1 &'
  redraw!
endfunction

augroup filtype_pandoc
  autocmd!
  autocmd FileType pandoc noremap <F5> :call PMarkdown()<CR>
augroup END
