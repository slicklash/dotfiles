function! ProfileStart()
    :profile start profile.log
    :profile func *
    :profile file *
endfunction

function! ProfileStop()
    :profile pause
    :noautocmd qall!
endfunction

function! Preserve(command)
    let l:last_view = winsaveview()
    let l:last_search = getreg('/')
    execute 'keepjumps ' . a:command
    call winrestview(l:last_view)
    call setreg('/', l:last_search)
endfunction

let g:show_syntax_item_in_statusline = 0

function! SyntaxItem()
    " if g:show_syntax_item_in_statusline == 1
        return synIDattr(synID(line('.'),col('.'),1),'name') . ' |'
    " endif
    " return ''
endfunction

function! ToggleSyntaxItem()
    if g:show_syntax_item_in_statusline == 0
        let g:show_syntax_item_in_statusline=1
    else
        let g:show_syntax_item_in_statusline=0
    endif
endfunction

function! EchoHi(msg, ...) abort
  let l:hi = a:0 > 1 ? a:2 : 'String'
  if l:hi ==? 'ErrorMsg'
      echohl ErrorMsg
  else
      echohl String
  endif
  echo a:msg
  echohl None
endfunction

function! _get(url, ...)
    let l:headers = a:0 > 0 ? { 'Authorization': 'Basic ' . webapi#base64#b64encode(a:1 . ':' . a:2) } : {}
    redraw | echon 'GET' . a:url . '...'
    return webapi#http#get(a:url, '', l:headers)
endfunction

function! _show(obj, ft)
    top new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowarn
    if a:ft == 'http/json'
        if len(a:obj.status) && a:obj.status[0] == '2' && len(a:obj.content)
            call setline(1, a:obj.content)
        else
            call setline(1, string(a:obj))
            silent %s/\v'([^']*)'/"\1"/g
        endif
        setlocal ft=json
    else
        call setline(1, string(a:obj))
    endif
    call JsBeautify()
    setlocal nomodifiable
endfunction

function! _search_to_local_list(term)
    let l:temp = expand('%')
    if !filereadable(l:temp)
        let l:temp = tempname()
        exec 'w ' . l:temp
    endif
    let l:search = 'lvimgrep ' . a:term . ' ' . l:temp
    exec l:search
    exec 'lopen'
endfunction

if !exists("*RunCode")
    function! RunCode() "{{{
        exec "w"
        if &ft =~ "fsharp"
            exec "QuickRun"
        " elseif &ft =~ "python"
        "     exec "!python3 %"
        elseif &ft =~ "sh"
            exec "!sh %"
        elseif &ft =~ "php"
            exec "!php %"
        elseif &ft =~ "vim"
            if expand('%') =~ 'aloneinthedark.vim'
                colorscheme aloneinthedark
            else
                exec "so %"
            endif
        elseif &ft =~ "cs"
            exec "!mono %:r.exe"
        else
            exec "QuickRun"
        endif
    endfunction
endif

function! _ioc()
   exec 'g/register type/normal gJ'
   exec 'v/register type/d'
   exec '%s/<register type="Cumulus.BoP.Settings.Interfaces.DataRepository.//g'
   exec '%s/<register type="Cumulus.BoP.Settings.Interfaces.BusinessManager.//g'
   exec '%s/\v,[^,]+\.([a-z]+).+/, \1 /g'
   exec '%s/\v^[^\.]+\.//g'
   exec 'normal ggVG='
   exec '%s/^/container.RegisterTransent</g'
   exec '%s/\v\s+$/>();/g'
endfunction


function! ExpandSnippet(file, snip, params) abort

    let l:file = $HOME . '/.vim/snippets/' . a:file

    if !filereadable(l:file)
        echoerr l:file . ' not found'
        return v:none
    endif

    let l:lines = readfile(l:file)
    let l:snip = []
    let l:collect = v:false

    for line in l:lines

        if line =~ 'snippet ' . a:snip . '$'
            let l:collect = v:true
            continue
        elseif l:collect && line =~ 'snippet'
            break
        endif

        if l:collect
            if line =~ '\v^(abbr|options)' | continue | endif
            let line = strpart(line, 2)
            let l:snip = add(l:snip, line)
        endif

    endfor

    if !len(l:snip)
        echoerr 'Snippet "' . a:snip . '" not found'
        return v:none
    endif

    let l:snip = join(l:snip, "\n")

    let l:pp = insert(a:params, '')
    let l:i = 0

    while l:i < len(l:pp)
        let l:snip = substitute(l:snip, '\v(\$\{'.l:i.'(:\h+)?\}|\$'.l:i.')', l:pp[l:i], 'g')
        let l:i += 1
    endwhile

    let l:missing = matchstr(l:snip, '\v\$\{\d(:\h+)?\}')
    if l:missing != ''
        echoerr 'Missing required parameter: ' . l:missing
        return v:none
    endif

    return split(l:snip, '\n')

endfunction
