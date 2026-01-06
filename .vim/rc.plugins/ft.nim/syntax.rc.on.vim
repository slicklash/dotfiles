call dein#add('zah/nim.vim', { 'rev': 'a15714fea392b0f06ff2b282921a68c7033e39a2' })

function! s:setup() abort
  syntax keyword nimTestSuite suite contained
  syntax keyword nimTestCase test contained
  syntax keyword nimTestCheck check contained

  syntax match nimTestSuiteDecl /\<suite\>\s*".\{-}"/ contains=nimTestSuite
  syntax match nimTestCaseDecl /\<test\>\s*".\{-}"/ contains=nimTestCase
  syntax match nimTestCheckCall /\<check\>\s\+.\+/ contains=nimTestCheck

  hi! link nimTestSuiteDecl String
  hi! link nimTestSuite Function

  hi! link nimTestCaseDecl String
  hi! link nimTestCase Function

  hi! link nimTestCheck Keyword
endfunction

autocmd User InitPost ++once call s:setup()

augroup filtype_nim
  autocmd!
  autocmd FileType nim call s:ft_nim()
augroup END

function! s:ft_nim() abort
  let b:keyword_lookup_url='https://nim-lang.org/docs/theindex.html\#%s'
  nnoremap <buffer> <silent><leader>i <cmd>call SortImports()<cr>
endfunction
