vim9script

packadd cfilter

def g:RemoveQFItems()
  var startln = line("'<") - 1
  var endln = line("'>") - 1
  var qfall = getqflist()
  var pos = getpos('.')
  remove(qfall, startln, endln)
  setqflist(qfall, 'r')
  setpos('.', pos)
enddef

def g:RemoveQFItem()
  var startln = line('.') - 1
  var qfall = getqflist()
  var pos = getpos('.')
  remove(qfall, startln)
  setqflist(qfall, 'r')
  setpos('.', pos)
enddef

def g:QFUnique()
  var seen: dict<number> = {}
  var n = 1
  var last = line('$')
  while n <= last
    var file = split(getline(n), '|')[0]
    if !has_key(seen, file)
      seen[file] = n - 1
    endif
    n += 1
  endwhile
  var take = sort(values(seen))
  var qfall = filter(getqflist(), (i, _) => index(take, i) > -1)
  setqflist(qfall, 'r')
enddef

def Cmp(x: dict<any>, y: dict<any>): number
  if bufname(x.bufnr) == bufname(y.bufnr)
    return x.lnum == y.lnum ? 0 : (x.lnum < y.lnum ? -1 : 1)
  endif
  return bufname(x.bufnr) < bufname(y.bufnr) ? -1 : 1
enddef

def CmpText(x: dict<any>, y: dict<any>): number
  var xt = trim(split(x.text, '/')[-1], "';")
  var yt = trim(split(y.text, '/')[-1], "';")
  return xt < yt ? -1 : 1
enddef

def g:QFSort(...rest: list<any>)
  var sortBy: string = get(rest, 0, 'file')
  if sortBy ==# 'text'
    setqflist(sort(getqflist(), CmpText))
  else
    setqflist(sort(getqflist(), Cmp))
  endif
enddef

def g:QFSave(file: string)
  var qf = getqflist({'all': 1})
  var items: list<dict<any>> = qf.items
  for i in range(len(items))
    var d = items[i]
    if bufexists(d.bufnr)
      d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! remove(d, 'bufnr')
    items[i] = d
  endfor
  writefile([js_encode(items)], file)
enddef

def g:QFLoad(file: string)
  setqflist(js_decode(get(readfile(file), 0)))
  copen
enddef

command! -nargs=1 -complete=file QFSave call QFSave(<f-args>)
command! -nargs=1 -complete=file QFLoad call QFLoad(<f-args>)

augroup my_qf
  autocmd!
  autocmd FileType qf nnoremap <silent><buffer> E <C-w><CR><C-w>L
  autocmd FileType qf nnoremap <silent><buffer> dd <Cmd>call RemoveQFItem()<CR>
  autocmd FileType qf xnoremap <silent><buffer> dd :<C-u>call RemoveQFItems()<CR>
  autocmd QuickfixCmdPost * g:QFSort()
augroup END
