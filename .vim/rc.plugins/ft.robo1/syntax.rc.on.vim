scriptencoding utf-8

augroup filtype_robo1
  autocmd!
  autocmd BufRead,BufNewFile *.robo1 call s:ft_robo1()
augroup END

function! s:ft_robo1() abort
  setfiletype robo1
  setlocal shiftwidth=2
  setlocal commentstring=#\ %s

  if exists('b:current_syntax')
    return
  endif

  let b:current_syntax = 'robo1'

  syntax match roboFunctionCall "[ąčęėįšųūžĄČĘĖĮŠŲŪŽA-Za-z]\k\+"

  syntax match roboKeyword "\."
  syntax keyword roboKeyword forward backward left right pen_down pen_up color print
  syntax keyword roboKeyword FORWARD BACKWARD LEFT RIGHT PEN_DOWN PEN_UP COLOR PRINT
  syntax keyword roboKeyword pirmyn atgal kairėn dešinėn piešk nepiešk spalva rašyk
  syntax keyword roboKeyword if  else when and or not
  syntax keyword roboKeyword jei kita kai  ir  arba nėra
  syntax keyword roboKeyword repeat while for in return  break   continue foreach
  syntax keyword roboKeyword kartok kol   su  iš grąžink nutrauk tęsk     kiekvienam visiems
  syntax keyword roboKeyword check   struct
  syntax keyword roboKeyword tikrink struktūra
  syntax match roboPreProc "\<\(TODO\|HACK\)\>" contained
  syntax match roboComment "#.*$" contains=roboPreProc
  syntax match roboDocString ';.*$'
  syntax match roboNumber "\(\d\(_\d\)*\|\d\+\.\d\+\)"
  syntax match roboString '"[^"]*"'

  syntax match roboOp "[\[\]@={}+\-\\/*<>|]"

  syntax match roboSpecialOp "\$"

  syntax match roboVariable ":\k\+"
  syntax match roboResult "\s*:\(rezultatas\|result\)"

  syntax match roboFunctionStart "^\s*\(tai\|fn\|here\) " nextgroup=roboFunctionName skipwhite
  syntax match roboFunctionName "[^@ :[]\+" contained

  syntax match roboLambdaStart "\\" nextgroup=roboArgs

  syntax region roboStringPart start="`" end="`" contains=roboInterpolationPart
  syntax region roboInterpolationPart start="\[" end="\]" contained contains=roboExpression
  syntax match roboExpression /\[\zs.\{-}\ze\]/ contained contains=roboFunctionCall,roboOp,roboSpecialOp,roboNumber,roboVariable

  syntax region roboMultilineComment start="#\[" end="#\]" contains=roboPreProc

  hi def link roboKeyword Keyword
  hi def link roboFunctionStart Keyword
  hi def link roboComment Comment
  hi def link roboMultilineComment Comment
  hi def link roboString String
  hi def link roboStringPart String
  hi def link roboDocString String
  hi def link roboNumber Number
  hi def link roboOp Operator
  hi def link roboInterpolationPart Operator
  hi def link roboSpecialOp Arg
  hi def link roboResult Operator
  hi def link roboPreProc PreProc
  hi def link roboFunctionName Function
  hi def link roboLambdaStart Function
  hi def link roboFunctionCall Function
endfunction
