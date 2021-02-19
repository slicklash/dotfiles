if InitStep() == 0
  let missing = Missing('rg', 'bat', 'delta')
  if !empty(missing)
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing '.missing
    cquit
  endif
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
  finish
endif

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-m': 'split',
  \ 'ctrl-l': 'vsplit',
  \ 'ctrl-n': 'tabedit' }

let g:fzf_options = ['--layout=reverse', '--info=inline']

function! _rg(ignores, ...)
  let rg_options = extend(['rg', '--hidden', '--no-ignore-vcs', '--column', '--line-number', '--no-heading', '--smart-case'], a:000)
  for item in a:ignores
    call extend(rg_options, ['--glob', '!' . item])
  endfor
  return join(rg_options, ' ')
endfunction

function! _fzf(...) abort
  let params = get(a:000, 0, {})
  let dir = get(params, 'dir')
  let ignore = get(params, 'ignore', ['.git', '__pycache__', 'node_modules', 'target', 'dist'])
  let grep = get(params, 'grep', '')
  let source = get(params, 'source', empty(grep) ? _rg(ignore, '--files') : _rg(ignore))
  let t = get(params, 'ft')
  if !empty(t)
    if t == '?'
      let t = input('Type: ')
    endif
    let source .= ' -t '. t
  endif
  let options = fzf#vim#with_preview({'source': source, 'options': g:fzf_options})
  if !empty(dir)
    let options.dir = dir
  endif
  if !empty(grep)
    call remove(options, 'source')
    call fzf#vim#grep(source . ' -- ' . grep, 1, options)
  else
    call fzf#run(fzf#wrap(options))
  endif
endfunction

function! SearchIn(dir, ...) abort
  let pattern = a:0 > 0 && a:1 != v:none ? a:1 : input('Pattern: ')
  let options = get(a:000, 1, {})
  if empty(pattern)
    return
  endif
  call _fzf(extend({'grep': pattern, 'dir': a:dir}, options))
endfunction

nnoremap <Space>f :call _fzf()<CR>
nnoremap <Space>F :call _fzf({'ft': '?'})<CR>
nnoremap <Space>a :call _fzf({'dir': '~/code/app-market/communities/'})<CR>
nnoremap <Space>A :call _fzf({'dir': '~/code/app-market/communities/', 'ft': '?'})<CR>

nnoremap <Space>c :call _fzf({'dir': '~/.vim/', 'ignore':['.denite', '.cache', 'cache', 'bundle*', '.dein', 'tmp']})<CR>
nnoremap <Space>z :call _fzf({'dir': '~/.zsh/'})<CR>
nnoremap <Space>` :call _fzf({'dir': '~/'})<CR>

nnoremap <Space>b :call fzf#vim#buffers('', fzf#vim#with_preview({'placeholder': "{1}", 'options': g:fzf_options}))<CR>

nnoremap <Space>d :call _fzf({'dir': expand('%:p:h')})<CR>
nnoremap <Space>h :Helptags<CR>
nnoremap <Space>r :call fzf#vim#history(fzf#vim#with_preview({'options': g:fzf_options}))<CR>

nnoremap <Leader>fd :call _fzf({'grep': expand('<cword>')})<CR>
nnoremap <Leader>fa :call _fzf({'grep': expand('<cword>'), 'dir': '~/code/app-market/communities'})<CR>


nnoremap <Space>/ :call SearchIn('')<CR>
nnoremap <Space>? :call SearchIn('', v:none, {'ft': '?'})<CR>
nnoremap <Space>\ :call SearchIn('~/code/app-market/communities')<CR>
nnoremap <Space>\| :call SearchIn('~/code/app-market/communities', v:none, {'ft': '?'})<CR>
