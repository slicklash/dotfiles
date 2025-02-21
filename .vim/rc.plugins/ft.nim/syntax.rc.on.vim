if InitStep() == 0
  call dein#add('zah/nim.vim', { 'rev': 'a15714fea392b0f06ff2b282921a68c7033e39a2' })
  finish
endif

augroup filtype_nim
  autocmd!
  autocmd FileType nim call s:ft_nim()
augroup END

function! s:ft_nim() abort

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

  let b:keyword_lookup_url='https://nim-lang.org/docs/theindex.html\#%s'
  " setlocal formatprg=nimpretty\ --indent:2
  nnoremap <buffer> <silent><leader>i :call SortImports()<cr>
endfunction
