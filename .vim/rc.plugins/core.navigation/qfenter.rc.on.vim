if InitStep() == 0
  packadd cfilter
  call dein#add('yssl/QFEnter', { 'rev': 'df0a75b287c210f98ae353a12bbfdaf73d858beb' })
  finish
endif

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['E']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>']
let g:qfenter_keymap.topen = ['<C-t>']

function! RemoveQFItems() range
  let start = line("'<") - 1
  let end = line("'>") - 1
  let qfall = getqflist()
  let pos = getpos('.')
  call remove(qfall, start, end)
  call setqflist(qfall, 'r')
  call setpos('.', pos)
endfunction

function! RemoveQFItem()
  let start = line('.') - 1
  let qfall = getqflist()
  let pos = getpos('.')
  call remove(qfall, start)
  call setqflist(qfall, 'r')
  call setpos('.', pos)
endfunction

function! QFUnique()
  let seen = {}
  let [n, last] = [1, line('$')]
  while n <= last
    let file = split(getline(n), '|')[0]
    if !has_key(seen, file)
      let seen[file] = n - 1
    endif
    let n += 1
  endwhile
  let take = sort(values(seen))
  let qfall = filter(getqflist(), {i -> index(take, i) > -1})
  call setqflist(qfall, 'r')
endfunction

function! s:cmp(x, y)
  if bufname(a:x.bufnr) == bufname(a:y.bufnr)
    return a:x.lnum == a:y.lnum ? 0 : (a:x.lnum < a:y.lnum ? -1 : 1)
  endif
  return bufname(a:x.bufnr) < bufname(a:y.bufnr) ? -1 : 1
endfunction

function! s:cmp_text(x, y)
  let x = split(a:x.text, '/')[-1]
  let y = split(a:y.text, '/')[-1]
  let x = trim(x, "';")
  let y = trim(y, "';")
  return x < y ? -1 : 1
endfunction

function! QFSort(...)
  let sortBy = get(a:, 1, 'file')
  if sortBy ==# 'text'
    call setqflist(sort(getqflist(), 's:cmp_text'))
  else
    call setqflist(sort(getqflist(), 's:cmp'))
  endif
endfunction

function! QFSave(file) abort
  let qf = getqflist({'all': 1})
  for i in range(len(qf.items))
    let d = qf.items[i]
    if bufexists(d.bufnr)
      let d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! call remove(d, 'bufnr')
    let qf.items[i] = d
  endfor
  call writefile([js_encode(qf.items)], a:file)
endfunction

function! QFLoad(file) abort
  call setqflist(js_decode(get(readfile(a:file), 0)))
  copen
endfunction

command! -nargs=1 -complete=file QFSave call QFSave(<f-args>)
command! -nargs=1 -complete=file QFLoad call QFLoad(<f-args>)

augroup my_qf
  autocmd! my_qf
  autocmd FileType qf nnoremap <silent> <buffer> dd :call RemoveQFItem()<cr>
  autocmd FileType qf vnoremap <silent> <buffer> dd :call RemoveQFItems()<cr>
  autocmd! QuickfixCmdPost * call QFSort()
augroup end
