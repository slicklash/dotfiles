vim9script

def Preview()
  update
  var pdf = expand('%:p:r') .. '.pdf'
  var out = system('dot -Tpdf ' .. shellescape(expand('%:p')) .. ' -o ' .. shellescape(pdf))
  if v:shell_error != 0
    echohl ErrorMsg
    echo trim(out)
    echohl None
    return
  endif
  system('open ' .. shellescape(pdf))
enddef

augroup filtype_dot
  autocmd!
  autocmd FileType dot setlocal commentstring=//\ %s
  autocmd FileType dot nnoremap <buffer> <F5> <ScriptCmd>Preview()<CR>
augroup END
