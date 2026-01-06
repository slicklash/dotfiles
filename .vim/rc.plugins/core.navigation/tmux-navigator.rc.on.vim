call dein#add('christoomey/vim-tmux-navigator', { 'rev': 'c45243dc1f32ac6bcf6068e5300f3b2b237e576a' })

let g:tmux_navigator_disable_when_zoomed = 1

augroup tmux_exec
  autocmd!
  autocmd FileType * call s:tmux_exec()
augroup END

function! _tmux_send(cmd) abort
  w
  let cmd = substitute(a:cmd, '%:p', expand('%:p'), '')
  let cmd = substitute(cmd, '$GIT', FugitiveFind('.git'), 'i')
  let cmd = substitute(cmd, '$HOME', $HOME, 'i')
  execute 'silent !tmux send-keys -t 1 "'.escape(cmd, '"').'" Enter'
endfunction

function! _js(cmd, ...) abort
  let path = expand('%:p')
  if path =~ '.spec.[jt]s'
    let type = get(a:000, 0, 'test')
    let args = get(a:000, 1, '')
    if path =~ 'axio'
      let cwd = fnamemodify(FindNearestFile('package.json'), ':p:h')
      let testCmd = path =~ 'e2e-test' ? 'test:e2e' : 'test'
      let cmd = printf('yarn --cwd %s %s %s %s', cwd, testCmd, args, path)
    else
      let test_cmd = 'npm test '
      let cmd = type == 'test' ? test_cmd . path : 'npx nyc -r html ' . test_cmd . ' --coverage ' . path
    endif
  else
    let cmd = substitute(a:cmd, '%:p', expand('%:p'), '')
  endif
  execute 'silent !tmux send-keys -t left "'.escape(cmd, '"').'" Enter'
endfunction

function! _python(cmd, ...) abort
  let type = get(a:000, 0, 'run')
  let cmd = type == 'run' ? 'python %:p' : a:cmd
  let path = expand('%:p')
  if path =~ 'test_.*\.py' && type != 'test'
    let cmd = 'pytest -svvv %:p'
  endif
  call _tmux_send(cmd)
endfunction


function! _open_shell() abort
  let cmd = fnamemodify(get(defx#get_candidate(), 'action__path'), ':p:h')
  execute 'silent !tmux splitw -c ' . cmd
endfunction


function! s:tmux_exec() abort
  if &filetype =~ 'defx'
    map <buffer> S <cmd>call _open_shell()<Bar>redraw!<C-M>
  elseif &filetype =~ 'python'
    map <buffer> <Leader>e <cmd>call _python('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call _python('pytest --cov=. --cov-report=html %:p', 'test')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call _tmux_send('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call _tmux_send('pypy3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>l <cmd>call _tmux_send('bash $GIT/hooks/pre-commit')<Bar>redraw!<C-M>
  elseif &filetype =~ 'javascript'
    map <buffer> <Leader>e <cmd>call _js(' node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call _js(' node %:p', 'test', '--coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>t <cmd>call _js(' node %:p', 'test', '--watch')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call _tmux_send(' node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'typescript'
    map <buffer> <Leader>e <cmd>call _js('node --no-warnings --experimental-transform-types %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call _js('node --no-warnings --experimental-transform-types %:p', 'test', '--coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>t <cmd>call _js('node --no-warnings --experimental-transform-types %:p', 'test', '--watch')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call _js('node --no-warnings --experimental-transform-types --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'java'
    map <buffer> <Leader>e <cmd>call _tmux_send('java %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'vim'
    map <buffer> <Leader>e <cmd>call _tmux_send('vim -enN -u NONE -i NONE --cmd "source %:p" --cmd ":q" 2>&1 \| cat')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call _tmux_send('vim --cmd "source %:p" --cmd ":q"')<Bar>redraw!<C-M>
  elseif &filetype =~ 'nim'
    map <buffer> <Leader>e <cmd>call _tmux_send('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call _tmux_send('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call _tmux_send('nim c -r -d:release --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>D <cmd>call _tmux_send('nim c --debugger:native %:p')<Bar>redraw!<C-M>
  elseif &filetype == 'er'
    map <buffer> <Leader>e <cmd>call _tmux_send('docker run --rm -i ghcr.io/marzocchi/erd:latest -f png < %:p >\| /tmp/er.png && o /tmp/er.png')<Bar>redraw!<C-M>
  elseif &filetype == 'robo1'
    map <buffer> <Leader>e <cmd>call _tmux_send(' ts-node --skipProject $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call _tmux_send(' ts-node --skipProject $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>M <cmd>call _tmux_send(' mtime ts-node --skipProject $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
  endif
  map <buffer> <Leader>r :execute 'silent !tmux send-keys -t 1 Up Enter'<Bar>redraw!<C-M>
endfunction
