if InitStep() == 0
  call dein#add('autozimu/LanguageClient-neovim', {
        \ 'rev': 'next',
        \ 'build': 'bash install.sh',
        \ })
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_changeThrottle = 0.5
  let g:LanguageClient_diagnosticsEnable = 0
  let g:LanguageClient_fzfContextMenu = 0
  let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'stable', 'rls'],
        \ 'python': ['/home/slicklash/.local/bin/pyls'],
        \ 'typescript': ['typescript-language-server', '--stdio'],
        \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
        \ 'javascript': ['typescript-language-server', '--stdio'],
        \ 'javascript.jsx': ['typescript-language-server', '--stdio'],
        \ 'nim': ['nimlsp'],
        \ }
  let g:LanguageClient_rootMarkers = {
        \ 'javascript': ['.prettierrc'],
        \ 'javascript.jsx': ['.prettierrc'],
        \ }
  finish
endif

" pip3 install python-language-server
" pip3 install 'python-language-server[rope]'

nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>:normal! m`<CR>
nnoremap <silent> <leader>b <C-o>

nnoremap <silent> <leader>rr :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>fr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <leader>h :call LanguageClient#textDocument_hover()<CR>

