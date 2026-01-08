call dein#add('github/copilot.vim', { 'rev': '206011a8bc5078a02560d5c44177e9849e8f8d6c' })

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:false,
\ 'css': v:false,
\ 'go': v:false,
\ 'java': v:false,
\ 'javascript': v:false,
\ 'make': v:false,
\ 'nim': v:false,
\ 'python': v:true,
\ 'robo1': v:false,
\ 'shell': v:false,
\ 'typescript': v:true,
\ 'vim': v:false,
\}
