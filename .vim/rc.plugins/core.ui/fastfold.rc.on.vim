vim9script

const slow_methods = ['syntax', 'expr']

def Freeze()
  if !empty(&l:buftype) || !&l:modifiable || line('$') <= 100
    return
  endif
  if index(slow_methods, &l:foldmethod) >= 0
    b:fastfold_fdm = &l:foldmethod
    setlocal foldmethod=manual
  endif
enddef

def Update()
  if exists('b:fastfold_fdm') && &l:foldmethod ==# 'manual'
    &l:foldmethod = b:fastfold_fdm
  endif
  Freeze()
enddef

nnoremap <silent> zuz <ScriptCmd>Update()<CR>

augroup fastfold
  autocmd!
  autocmd BufWinEnter,BufWritePost * Update()
augroup END
