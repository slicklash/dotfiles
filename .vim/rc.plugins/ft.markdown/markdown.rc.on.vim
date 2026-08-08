vim9script

g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'typescript']

def SedInplace(cmd: string, file: string)
  if has('macunix')
    execute 'silent !sed -i '''' ' .. shellescape(cmd, true) .. ' ' .. shellescape(file, true)
  else
    execute 'silent !sed -i ' .. shellescape(cmd, true) .. ' ' .. shellescape(file, true)
  endif
enddef

def OpenBrowser(path: string)
  if has('macunix')
    execute 'silent !open -a "Brave Browser" ' .. shellescape(path, true) .. ' >/dev/null 2>&1 &'
  else
    execute 'silent !firefox ' .. shellescape(path, true) .. ' >/dev/null 2>&1 &'
  endif
enddef

def g:PMarkdown()
  execute 'silent !cp ' .. shellescape($HOME .. '/.config/gh.css', true) .. ' /tmp/gh.css'
  execute 'silent !pandoc ' .. shellescape(expand('%:p'), true) .. ' -s -c gh.css -o /tmp/_pmd.html'

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
augroup END
