vim9script

g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript']

def SedInplace(cmd: string, file: string)
  if has('macunix')
    execute 'silent !sed -i '''' ' .. shellescape(cmd) .. ' ' .. shellescape(file)
  else
    execute 'silent !sed -i ' .. shellescape(cmd) .. ' ' .. shellescape(file)
  endif
enddef

def OpenBrowser(path: string)
  if has('macunix')
    execute 'silent !open -a "Firefox" ' .. shellescape(path) .. ' >/dev/null 2>&1 &'
  else
    execute 'silent !firefox ' .. shellescape(path) .. ' >/dev/null 2>&1 &'
  endif
enddef

def g:PMarkdown()
  execute 'silent !cp ' .. shellescape($HOME .. '/.config/gh.css') .. ' /tmp/gh.css'
  execute 'silent !pandoc ' .. shellescape(expand('%:p')) .. ' -s -c gh.css -o /tmp/_pmd.html'

  SedInplace('/<colgroup>/,/<\/colgroup>/d', '/tmp/_pmd.html')
  SedInplace('s/<style>/<style>pre{background-color:#f6f8fa}/g', '/tmp/_pmd.html')

  OpenBrowser('/tmp/_pmd.html')
  redraw!
enddef

def g:FPreview()
  OpenBrowser(expand('%:p'))
  redraw!
enddef

augroup filetype_pandoc
  autocmd!
  autocmd FileType pandoc,markdown nnoremap <silent><buffer> <F5> <Cmd>call PMarkdown()<CR>
  autocmd FileType pandoc,markdown setlocal nospell
augroup END
