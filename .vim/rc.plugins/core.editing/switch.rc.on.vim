if InitStep() == 0
  call dein#add('AndrewRadev/switch.vim', { 'rev': '4017a58f7ed8a2d76a288e36130affe8eb55e83a' })
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

  let from_double = '"\([^"]\+\)"'
  let from_single = '''\([^'']\+\)'''
  let from_backtick = '`\([^`]\+\)`'

  let to_single = '''\1'''
  let to_double = '"\1"'
  let to_backtick = '`\1`'

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
          \     from_double: to_single,
          \     from_single: to_backtick,
          \     from_backtick: to_double,
          \     '\\"\(\[[^\\]\+\)\\''\([^\\]\+\)\\''\]\\"': '''\1"\2"]''',
          \   },
          \   g:switch_builtins.javascript_function,
          \   g:switch_builtins.javascript_arrow_function,
          \   g:switch_builtins.javascript_es6_declarations,
          \ ]
  elseif &ft == 'nim'
    let b:switch_custom_definitions =
          \ [
          \   {
          \     '\C\<var\>': 'let',
          \     '\C\<let\>': 'var',
          \     from_double: to_single,
          \     from_single: to_double,
          \   },
          \ ]
  elseif &ft == 'java'
    let b:switch_custom_definitions =
          \ [
          \   ['public', 'private', 'protected'],
          \ ]
  else
    let b:switch_custom_definitions =
          \ [
          \   {
          \     'enabled': 'disabled',
          \     'disabled': 'enabled',
          \     from_double: to_single,
          \     from_single: to_double,
          \   },
          \ ]
  endif
endfunction

noremap <silent> <leader><space> :Switch<CR>
