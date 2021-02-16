if InitStep() == 0
  finish
endif

let s:react_comp = {
      \ 'is_selectable' : 0,
      \ }

function! s:react_comp.func(candidates) abort

  let dir = a:candidates.action__path . '/'

  call inputsave()
  let name = input('Name: ')
  call inputrestore()
  normal :<ESC>

  let dir .= name . '/'

  if isdirectory(dir)
    echohl ErrorMsg | echo 'Directory already exists' | echohl None
    return
  endif

  call mkdir(dir)

  let ToCamelCase = {text -> join(map(split(text, '-'), {_, val -> substitute(val,'\(.*\)', '\u\1', 'g') }), '')}

  let F = { n, p -> ExpandSnippet('javascript/react.snip', n, p) }

  let component_name = ToCamelCase(name)
  let files = [
        \   ['index.js', [printf("export { default } from './%s';", name)]],
        \   [name . '.js', F('rco', [name, component_name])],
        \   [name . '.scss', ['.container {', '}']],
        \ ]

  for [fileName, lines] in files
    call writefile(lines, dir . fileName)
  endfor

  call vimfiler#view#_redraw_screen()
endfunction

" call unite#custom#action('directory', 'new react component', s:react_comp)
