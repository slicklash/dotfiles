vim9script

dein#add('christoomey/vim-tmux-navigator', {'rev': 'e41c431a0c7b7388ae7ba341f01a0d217eb3a432'})

g:tmux_navigator_disable_when_zoomed = 1

def g:TmuxSend(cmd: string)
  write
  var c = substitute(cmd, '%:p', expand('%:p'), '')
  c = substitute(c, '$GIT', g:FugitiveFind('.git'), 'i')
  c = substitute(c, '$HOME', $HOME, 'i')
  execute 'silent !tmux send-keys -t 1 "' .. escape(c, '"') .. '" Enter'
enddef

def g:RunJs(cmd: string, ...rest: list<any>)
  var path = expand('%:p')
  var c: string
  if path =~ '.spec.[jt]s'
    var runType: string = get(rest, 0, 'test')
    var args: string = get(rest, 1, '')
    if path =~ 'axio'
      var cwd = fnamemodify(g:FindNearestFile('package.json'), ':p:h')
      var testCmd = path =~ 'e2e-test' ? 'test:e2e' : 'test'
      c = printf('yarn --cwd %s %s %s %s', cwd, testCmd, args, path)
    else
      var test_cmd = 'npm test '
      c = runType == 'test' ? test_cmd .. path : 'npx nyc -r html ' .. test_cmd .. ' --coverage ' .. path
    endif
  else
    c = substitute(cmd, '%:p', expand('%:p'), '')
  endif
  execute 'silent !tmux send-keys -t left "' .. escape(c, '"') .. '" Enter'
enddef

def g:RunPython(cmd: string, ...rest: list<any>)
  var runType: string = get(rest, 0, 'run')
  var c = runType == 'run' ? 'python %:p' : cmd
  var path = expand('%:p')
  if path =~ 'test_.*\.py' && runType != 'test'
    c = 'pytest -svvv %:p'
  endif
  g:TmuxSend(c)
enddef

def TmuxExec()
  if &filetype =~ 'python'
    map <buffer> <Leader>e <cmd>call RunPython('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call RunPython('pytest --cov=. --cov-report=html %:p', 'test')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call TmuxSend('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call TmuxSend('pypy3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>l <cmd>call TmuxSend('bash $GIT/hooks/pre-commit')<Bar>redraw!<C-M>
  elseif &filetype =~ 'javascript'
    map <buffer> <Leader>e <cmd>call RunJs(' node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call RunJs(' node %:p', 'test', '--coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>t <cmd>call RunJs(' node %:p', 'test', '--watch')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call TmuxSend(' node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'typescript'
    map <buffer> <Leader>e <cmd>call RunJs('node --no-warnings --experimental-transform-types %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>c <cmd>call RunJs('node --no-warnings --experimental-transform-types %:p', 'test', '--coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>t <cmd>call RunJs('node --no-warnings --experimental-transform-types %:p', 'test', '--watch')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call RunJs('node --no-warnings --experimental-transform-types --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'java'
    map <buffer> <Leader>e <cmd>call TmuxSend('java %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'vim'
    map <buffer> <Leader>e <cmd>call TmuxSend('vim -enN -u NONE -i NONE --cmd "source %:p" --cmd ":q" 2>&1 \| cat')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call TmuxSend('vim --cmd "source %:p" --cmd ":q"')<Bar>redraw!<C-M>
  elseif &filetype =~ 'nim'
    map <buffer> <Leader>e <cmd>call TmuxSend('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call TmuxSend('nim c -r -d:ssl --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E <cmd>call TmuxSend('nim c -r -d:release --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>D <cmd>call TmuxSend('nim c --debugger:native %:p')<Bar>redraw!<C-M>
  elseif &filetype == 'er'
    map <buffer> <Leader>e <cmd>call TmuxSend('docker run --rm -i ghcr.io/marzocchi/erd:latest -f png < %:p >\| /tmp/er.png && o /tmp/er.png')<Bar>redraw!<C-M>
  elseif &filetype == 'robo1'
    map <buffer> <Leader>e <cmd>call TmuxSend(' tsx $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>m <cmd>call TmuxSend(' tsx $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>M <cmd>call TmuxSend(' mtime tsx $HOME/code/robo1/src/robo-lang/interpreter.ts %:p')<Bar>redraw!<C-M>
  endif
  map <buffer> <Leader>r :execute 'silent !tmux send-keys -t 1 Up Enter'<Bar>redraw!<C-M>
enddef

augroup tmux_exec
  autocmd!
  autocmd FileType * TmuxExec()
augroup END
