if InitStep() == 0 && exists('$TMUX')
  call dein#add('christoomey/vim-tmux-navigator')
  finish
endif

let g:tmux_navigator_disable_when_zoomed = 1

augroup tmux_exec
  autocmd!
  autocmd FileType * call s:tmux_exec()
augroup END

function! _tmux_send(cmd) abort
  let cmd = substitute(a:cmd, '%:p', expand('%:p'), '')
  execute 'silent !tmux send-keys -t left "'.escape(cmd, '"').'" Enter'
endfunction

function! _tmux_js(cmd, ...) abort
  let path = expand('%:p')
  if path =~ '.spec.js'
    let type = get(a:, 0, 'test')
    if path =~ 'app-market'
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

function! s:tmux_exec() abort
  if &filetype =~ 'python'
    map <buffer> <Leader>e :call _tmux_send('python3 %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('pypy3 %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'javascript'
    map <buffer> <Leader>c :call _tmux_js('node %:p', 'coverage')<Bar>redraw!<C-M>
    map <buffer> <Leader>e :call _tmux_js('node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'typescript'
    map <buffer> <Leader>e :call _tmux_send('ts-node %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('ts-node --inspect-brk %:p')<Bar>redraw!<C-M>
  elseif &filetype =~ 'vim'
    map <buffer> <Leader>e :call _tmux_send('vim -enN -u NONE -i NONE --cmd "source %:p" --cmd ":q" 2>&1 \| cat')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('vim --cmd "source %:p" --cmd ":q"')<Bar>redraw!<C-M>
  elseif &filetype =~ 'nim'
    map <buffer> <Leader>e :call _tmux_send('nim c -r --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>E :call _tmux_send('nim c -r -d:release --hints:off %:p')<Bar>redraw!<C-M>
    map <buffer> <Leader>D :call _tmux_send('nim c --debugger:native %:p')<Bar>redraw!<C-M>
  endif
  map <buffer> <Leader>r :execute 'silent !tmux send-keys -t left Up Enter'<Bar>redraw!<C-M>
endfunction

function! MapMocha() abort
  nnoremap <Leader>e :execute 'silent !tmux send-keys -t left npx\ nyc\ -r\ html\ mocha\ '.expand('%:p').' Enter'<Bar>redraw!<C-M>
endfunction
