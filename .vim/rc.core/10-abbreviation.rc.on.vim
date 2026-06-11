vim9script

# Command-line abbreviations (command-position only)
def CmdAbbrev(lhs: string, rhs: string)
  execute printf(
        \ 'cnoremap <expr> %s getcmdtype() == ":" && getcmdpos() == 1 ? "%s" : "%s"',
        \ lhs, rhs, lhs
        \ )
enddef

CmdAbbrev('git', 'Git ')
CmdAbbrev('Cd',  'cd')
CmdAbbrev('ww',  'w !sudo tee > /dev/null %')
CmdAbbrev('cf',   'Cfilter ')
CmdAbbrev('nf',  'Cfilter! ')

CmdAbbrev('W',    'w')
CmdAbbrev('Q',    'q')
CmdAbbrev('WQ',   'wq')
CmdAbbrev('Wq',   'wq')
CmdAbbrev('Qa',   'qa')
CmdAbbrev('QA',   'qa')
CmdAbbrev('Qall', 'qall')
CmdAbbrev('So',   'so')

CmdAbbrev('SS', 'mksession!')
CmdAbbrev('SR', 'source Session.vim')
