call dein#add('yegappan/lsp', { 'rev': '58720a3a106ad0f78b05d97da67639288af30ebf' })

" \ 'c': ['ccls', '--log-file=/tmp/ccls.log', '--init={"cacheDirectory":"/home/slicklash/.cache/ccls", "completion": {"filterAndSort": false}}'],
" \ 'rust': ['rustup', 'run', 'stable', 'rls'],
" \ 'java': ['/home/slicklash/bin/java-lsp/eclipse-jdt-ls'],

let lspOpts = #{
      \ autoComplete: v:false,
      \ omniComplete: v:true,
      \ autoHighlightDiags: v:true,
      \ usePopupInCodeAction: v:true,
      \ diagSignErrorText: '✖',
      \ diagSignWarningText: '⚠',
      \ diagSignInfoText: 'ℹ',
      \ diagSignHintText: '➤',
      \ showDiagOnStatusLine: v:true,
      \ }
autocmd User LspSetup call LspOptionsSet(lspOpts)

" pynvim python-lsp-server python-lsp-ruff

let lspServers = [
      \ {
      \    'name': 'golang',
      \    'filetype': ['go', 'gomod'],
      \    'path': 'gopls',
      \    'args': ['serve'],
      \    'syncInit': v:true
      \ },
      \ {
      \   'name': 'nimlang',
      \   'filetype': ['nim'],
      \   'path': 'nimlangserver',
      \ },
      \ {
      \   'name': 'pylsp',
      \   'filetype': ['python'],
      \   'path': exists('$PREFIX') ? ($PREFIX .. '/bin/pylsp') : 'pylsp',
      \   'args': ['--log-file', $TMPDIR . '/pylsp.log'],
      \ },
      \ {
      \    'name': 'typescriptlang',
      \    'filetype': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'],
      \    'path': 'typescript-language-server',
      \    'args': ['--stdio'],
      \    'workspaceConfig': {
      \        'javascript': { 'format': { 'indentSize': 2, 'tabSize': 2 } },
      \        'typescript': { 'format': { 'indentSize': 2, 'tabSize': 2 } }
      \     },
      \ },
      \ {
      \   'name': 'vimls',
      \   'filetype': 'vim',
      \   'path': 'vim-language-server',
      \   'args': ['--stdio']
      \ }]
autocmd User LspSetup call LspAddServer(lspServers)

function! s:setup() abort
  nnoremap <silent> gd <cmd>LspGotoDefinition<CR>
  nnoremap <silent> <leader>b <C-o>

  nnoremap <silent> <leader>rr <cmd>LspRename<CR>
  nnoremap <silent> <leader>fr <cmd>LspShowReferences<CR>
  nnoremap <silent> <leader>h <cmd>LspHover<CR>
  nnoremap <silent> <leader>q <cmd>LspCodeAction<CR>
  nnoremap <silent> <leader>n <cmd>LspDiagNextWrap<CR>
  nnoremap <silent> <leader>N <cmd>LspDiagPrevWrap<CR>
endfunction

autocmd User InitPost ++once call s:setup()
