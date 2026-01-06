" Command-line abbreviations (command-position only)
function! s:CmdAbbrev(lhs, rhs) abort
  execute printf(
        \ 'cnoremap <expr> %s getcmdtype() == ":" && getcmdpos() == 1 ? "%s" : "%s"',
        \ a:lhs, a:rhs, a:lhs
        \ )
endfunction

call s:CmdAbbrev('git', 'Git ')
call s:CmdAbbrev('Cd',  'cd')
call s:CmdAbbrev('ww',  'w !sudo tee > /dev/null %')
call s:CmdAbbrev('cf',   'Cfilter ')
call s:CmdAbbrev('nf',  'Cfilter! ')

call s:CmdAbbrev('W',    'w')
call s:CmdAbbrev('Q',    'q')
call s:CmdAbbrev('WQ',   'wq')
call s:CmdAbbrev('Wq',   'wq')
call s:CmdAbbrev('Qa',   'qa')
call s:CmdAbbrev('QA',   'qa')
call s:CmdAbbrev('Qall', 'qall')

call s:CmdAbbrev('SS', 'mksession!')
call s:CmdAbbrev('SR', 'source Session.vim')
