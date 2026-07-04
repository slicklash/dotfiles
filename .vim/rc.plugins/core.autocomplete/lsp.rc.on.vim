vim9script

dein#add('yegappan/lsp', {'rev': '989016ae2ae4cbf304a9ca29478f47fec794493f'})

# \ 'c': ['ccls', '--log-file=/tmp/ccls.log', '--init={"cacheDirectory":"/home/slicklash/.cache/ccls", "completion": {"filterAndSort": false}}'],
# \ 'rust': ['rustup', 'run', 'stable', 'rls'],
# \ 'java': ['/home/slicklash/bin/java-lsp/eclipse-jdt-ls'],

var lspOpts = {
      \ autoComplete: false,
      \ omniComplete: true,
      \ autoHighlightDiags: true,
      \ usePopupInCodeAction: true,
      \ diagSignErrorText: '✖',
      \ diagSignWarningText: '⚠',
      \ diagSignInfoText: 'ℹ',
      \ diagSignHintText: '➤',
      \ showDiagOnStatusLine: true,
      \ }

# pynvim python-lsp-server python-lsp-ruff

var lspServers = [
      \ {
      \ 'name': 'golang',
      \ 'filetype': ['go', 'gomod'],
      \ 'path': 'gopls',
      \ 'args': ['serve'],
      \ 'syncInit': true,
      \ },
      \ {
      \ 'name': 'nimlang',
      \ 'filetype': ['nim'],
      \ 'path': 'nimlangserver',
      \ },
      \ {
      \ 'name': 'pylsp',
      \ 'filetype': ['python'],
      \ 'path': exists('$PREFIX') ? ($PREFIX .. '/bin/pylsp') : 'pylsp',
      \ 'args': ['--log-file', $TMPDIR .. '/pylsp.log'],
      \ },
      \ {
      \ 'name': 'typescriptlang',
      \ 'filetype': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'],
      \ 'path': 'typescript-language-server',
      \ 'args': ['--stdio'],
      \ 'workspaceConfig': {
      \ 'javascript': {'format': {'indentSize': 2, 'tabSize': 2}},
      \ 'typescript': {'format': {'indentSize': 2, 'tabSize': 2}},
      \ },
      \ },
      \ {
      \ 'name': 'vimls',
      \ 'filetype': 'vim',
      \ 'path': exists('$PREFIX') ? ($PREFIX .. '/bin/vim-language-server') : 'vim-language-server',
      \ 'args': ['--stdio'],
      \ }]

def OnLspSetup()
  g:LspOptionsSet(lspOpts)
  g:LspAddServer(lspServers)
enddef

autocmd User LspSetup OnLspSetup()

def Setup()
  nnoremap <silent> gd <cmd>LspGotoDefinition<CR>
  nnoremap <silent> <leader>b <C-o>

  nnoremap <silent> <leader>rr <cmd>LspRename<CR>
  nnoremap <silent> <leader>fr <cmd>LspShowReferences<CR>
  nnoremap <silent> <leader>h <cmd>LspHover<CR>
  nnoremap <silent> <leader>q <cmd>LspCodeAction<CR>
  nnoremap <silent> <leader>n <cmd>LspDiagNextWrap<CR>
  nnoremap <silent> <leader>N <cmd>LspDiagPrevWrap<CR>
enddef

autocmd User InitPost ++once Setup()
