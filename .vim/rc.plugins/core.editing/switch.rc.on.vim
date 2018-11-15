if InitStep() == 0
  call dein#add('AndrewRadev/switch.vim')
  finish
endif

augroup switch_js_ts
  autocmd!
  autocmd FileType * call s:init_switch_definitions()
augroup END

function! s:init_switch_definitions() abort
  if &ft =~ 'denite'
    return
  endif

  let l:from_double = '"\([^"]\+\)"'
  let l:from_single = '''\([^'']\+\)'''
  let l:from_backtick = '`\([^`]\+\)`'

  let l:to_single = '''\1'''
  let l:to_double = '"\1"'
  let l:to_backtick = '`\1`'

  if &ft =~ 'script'
    let b:switch_custom_definitions =
          \ [
          \   {
          \     '==' : '===',
          \     '!=' : '!==',
          \     'describe(' : 'describe.only(',
          \     'describe.only(' : 'describe.skip(',
          \     'describe.skip(' : 'describe(',
          \     'it(' : 'it.only(',
          \     'it.only(' : 'it.skip(',
          \     'it.skip(' : 'it(',
          \     'new': 'old',
          \     'old': 'new',
          \     'enabled': 'disabled',
          \     'disabled': 'enabled',
          \     l:from_double: l:to_single,
          \     l:from_single: l:to_backtick,
          \     l:from_backtick: l:to_double,
          \     '\\"\(\[[^\\]\+\)\\''\([^\\]\+\)\\''\]\\"': '''\1"\2"]''',
          \   },
          \   g:switch_builtins.javascript_function,
          \   g:switch_builtins.javascript_arrow_function,
          \   g:switch_builtins.javascript_es6_declarations,
          \ ]
  else
    let b:switch_custom_definitions =
          \ [
          \   {
          \     'enabled': 'disabled',
          \     'disabled': 'enabled',
          \     l:from_double: l:to_single,
          \     l:from_single: l:to_double,
          \   },
          \ ]
  endif
endfunction

" '\\''\([^'']\+\)\\''': '''\1''',
" '\\"\([^"\\]\+\)\\"': '''\1''',


noremap <silent> <leader><space> :Switch<CR>
