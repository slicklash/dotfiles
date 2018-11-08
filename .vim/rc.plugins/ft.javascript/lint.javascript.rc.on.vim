if !dein#tap('syntastic')
    finish
elseif InitStep() == 0
    call dein#add('mtscout6/syntastic-local-eslint.vim')
    finish
endif

" let g:syntastic_javascript_checkers=['eslint', 'jslint']
" let g:syntastic_javascript_jshint_args = '--config '.$HOME.'/.jshintrc'
"
" function! ToggleESLintArgs()
"
"     if exists('g:syntastic_javascript_eslint_args')
"         unlet g:syntastic_javascript_eslint_args
"     else
"         let g:syntastic_javascript_eslint_args = '--max-warnings 200 --config '.$HOME.'/.eslintrc'
"     endif
"
" endfunction

