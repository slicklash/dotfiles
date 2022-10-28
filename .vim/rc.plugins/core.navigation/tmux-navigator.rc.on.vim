if InitStep() == 0 && exists('$TMUX')
  call dein#add('christoomey/vim-tmux-navigator', { 'rev': 'bd4c38be5b4882991494cf77c0601a55bc45eebf' })
  finish
endif

let g:tmux_navigator_disable_when_zoomed = 1

augroup tmux_exec
  autocmd!
  autocmd FileType * call s:tmux_exec()
augroup END

function! _tmux_send(cmd) abort
  w
  let cmd = substitute(a:cmd, '%:p', expand('%:p'), '')
  let cmd = substitute(cmd, '$GIT', FugitiveFind('.git'), 'i')
  execute 'silent !tmux send-keys -t 1 "'.escape(cmd, '"').'" Enter'
endfunction

function! _tmux_js(cmd, ...) abort
  let path = expand('%:p')
  if path =~ '.spec.[jt]s'
    let type = get(a:, 0, 'test')
    if path =~ 'blog-ooi'
      " let test_cmd = 'npx yoshi-flow-editor test '
      let test_cmd = 'yarn run test:unit -- '
    elseif path =~ 'blog-bm'
      let test_cmd = 'yarn run test:unit -- '
    elseif path =~ 'bookings' || path =~ 'blog-bm'
      let test_cmd = 'npx yoshi-flow-bm test '
    elseif path =~ 'app-market'
      let test_cmd = path =~ 'client-common' ? 'npx yoshi-library test ' : 'npx yoshi test '
    else
      let test_cmd = 'npm test '
    endif
    let cmd = type == 'test' ? test_cmd . path : 'npx nyc -r html ' . test_cmd . ' --coverage ' . path
  else
    let cmd = substitute(a:cmd, '%:p', expand('%:p'), '')
  endif
  execute 'silent !tmux send-keys -t left "'.escape(cmd, '"').'" Enter'
endfunction

function! _python(cmd, ...) abort
  let type = get(a:000, 0, 'run')
  let cmd = type == 'run' ? 'python %:p' : a:cmd
  let path = expand('%:p')
  if path =~ 'test_.*\.py'
    let cmd = 'pytest %:p'
    if type == 'coverage'
      let cmd = cmd . ' --cov=. --cov-report=html'
    endif
  endif
  call _tmux_send(cmd)
endfunction


function! s:tmux_exec() abort
  if &filetype =~ 'python'
    map <buffer> <Leader>e :call _python('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c :call _python('pytest %:p', 'coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>m :call _tmux_send('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('pypy3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>l :call _tmux_send('bash $GIT/hooks/pre-commit')<Bar>redraw!<C-M>
  elseif &filetype =~ 'javascript' || expand('%:p') =~ 'app-market'
    map <buffer> <Leader>c :call _tmux_js('node %:p', 'coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>e :call _tmux_js('node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'typescript'
    map <buffer> <Leader>c :call _tmux_js('ts-node %:p', 'coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>e :call _tmux_js('ts-node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_js('ts-node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'vim'
    map <buffer> <Leader>e :call _tmux_send('vim -enN -u NONE -i NONE --cmd "source %:p" --cmd ":q" 2>&1 \| cat')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('vim --cmd "source %:p" --cmd ":q"')<Bar>redraw!<C-M>
  elseif &filetype =~ 'nim'
    map <buffer> <Leader>e :call _tmux_send('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>m :call _tmux_send('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('nim c -r -d:release --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>D :call _tmux_send('nim c --debugger:native %:p')<Bar>redraw!<C-M>
  endif
  map <buffer> <Leader>r :execute 'silent !tmux send-keys -t 1 Up Enter'<Bar>redraw!<C-M>
endfunction

