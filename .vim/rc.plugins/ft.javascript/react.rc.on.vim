if InitStep() == 0
    finish
endif

let s:react_comp = {
\ 'is_selectable' : 0,
\ }

function! s:react_comp.func(candidates) abort

    let l:dir = a:candidates.action__path . '/'

    call inputsave()
    let l:name = input('Name: ')
    call inputrestore()
    normal :<ESC>

    let l:dir .= l:name . '/'

    if isdirectory(l:dir)
        echohl ErrorMsg | echo 'Directory already exists' | echohl None
        return
    endif

    call mkdir(l:dir)

    let l:ToCamelCase = {text -> join(map(split(text, '-'), {_, val -> substitute(val,'\(.*\)', '\u\1', 'g') }), '')}

    let l:F = { n, p -> ExpandSnippet('javascript/react.snip', n, p) }

    let l:component_name = l:ToCamelCase(l:name)
    let l:files = [
        \   ['index.js', [printf("export { default } from './%s';", l:name)]],
        \   [l:name . '.js', l:F('rco', [l:name, l:component_name])],
        \   [l:name . '.scss', ['.container {', '}']],
        \ ]

    for [l:fileName, l:lines] in l:files
        call writefile(l:lines, l:dir . l:fileName)
    endfor

    call vimfiler#view#_redraw_screen()
endfunction

call unite#custom#action('directory', 'new react component', s:react_comp)
