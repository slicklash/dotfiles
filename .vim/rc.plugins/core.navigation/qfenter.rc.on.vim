if InitStep() == 0
  call dein#add('yssl/QFEnter')
  finish
endif

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.vopen = ['E']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>']
let g:qfenter_keymap.topen = ['<C-t>']

function! RemoveQFItems() range
  let l:start = line("'<") - 1
  let l:end = line("'>") - 1
  let l:qfall = getqflist()
  let l:pos = getpos('.')
  call remove(l:qfall, l:start, l:end)
  call setqflist(l:qfall, 'r')
  call setpos('.', l:pos)
endfunction

function! RemoveQFItem()
  let l:start = line('.') - 1
  let l:qfall = getqflist()
  let l:pos = getpos('.')
  call remove(l:qfall, l:start)
  call setqflist(l:qfall, 'r')
  call setpos('.', l:pos)
endfunction

function! QFUnique()
  let l:seen = {}
  let [l:n, l:last] = [1, line('$')]
  while l:n <= l:last
    let l:file = split(getline(l:n), '|')[0]
    if !has_key(l:seen, l:file)
      let l:seen[l:file] = l:n - 1
    endif
    let l:n += 1
  endwhile
  let l:take = sort(values(l:seen))
  let l:qfall = filter(getqflist(), {i -> index(l:take, i) > -1})
  call setqflist(l:qfall, 'r')
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
  if sortBy == 'text'
    call setqflist(sort(getqflist(), 's:cmp_text'))
  else
    call setqflist(sort(getqflist(), 's:cmp'))
  endif
endfunction

function! QFSave() abort
  let l:qf = getqflist({'all': 1})
  for i in range(len(l:qf.items))
    let d = l:qf.items[i]
    if bufexists(d.bufnr)
      let d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! call remove(d, 'bufnr')
    let l:qf.items[i] = d
  endfor
  return l:qf
endfunction

augroup my_qf
  autocmd! my_qf
  autocmd FileType qf nnoremap <silent> <buffer> dd :call RemoveQFItem()<cr>
  autocmd FileType qf vnoremap <silent> <buffer> dd :call RemoveQFItems()<cr>
  autocmd FileType qf nnoremap <silent> <buffer> ,U :call QFUnique()<cr>
  autocmd! QuickfixCmdPost * call QFSort()
augroup end
