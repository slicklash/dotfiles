if InitStep() == 0
  call dein#add('autozimu/LanguageClient-neovim', { 'rev': 'next', 'build': 'bash install.sh' })
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_selectionUI_autoOpen = 0
  let g:LanguageClient_changeThrottle = 0.5
  let g:LanguageClient_diagnosticsList = 'Location'
  let g:LanguageClient_selectionUI = 'fzf'
  " let g:LanguageClient_diagnosticsEnable = 0
  " let g:LanguageClient_fzfContextMenu = 1
        " \ 'java': ['/home/slicklash/bin/java-lsp/bin/jdtls', '--jvm-arg=-Dlog.level=ALL'],
        " \ 'python': ['/home/slicklash/.local/bin/pylsp'],
        " \ 'java': ['/home/slicklash/bin/java-lsp/eclipse-jdt-ls'],
  let g:LanguageClient_serverCommands = {
        \ 'go': ['gopls'],
        \ 'rust': ['rustup', 'run', 'stable', 'rls'],
        \ 'python': ['pylsp'],
        \ 'typescript': ['typescript-language-server', '--stdio'],
        \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
        \ 'java': ['/home/slicklash/bin/java-lsp/eclipse-jdt-ls'],
        \ 'javascript': ['typescript-language-server', '--stdio'],
        \ 'javascript.jsx': ['typescript-language-server', '--stdio'],
        \ 'nim': ['nimlsp'],
        \ }
  let g:LanguageClient_rootMarkers = {
        \ 'java': ['pom.xml'],
        \ 'javascript': ['tsconfig.json', '.prettierrc', '.nvmrc'],
        \ 'javascript.jsx': ['tsconfig.json', '.prettierrc', '.nvmrc'],
        \ 'typescript': ['tsconfig.json'],
        \ 'typescript.tsx': ['tsconfig.json'],
        \ }
  let g:LanguageClient_settingsPath = '~/.vim/settings.json'
  finish
endif

let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_loggingFile =  expand('/tmp/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('/tmp/LanguageServer.log')


" pip3 install python-language-server
" pip3 install 'python-language-server[rope]'

nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>:normal! m`<CR>
nnoremap <silent> <leader>b <C-o>

nnoremap <silent> <leader>rr :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>fr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <leader>h :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <leader>q :call LanguageClient#textDocument_codeAction()<CR>

