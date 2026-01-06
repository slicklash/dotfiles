call dein#add('github/copilot.vim', { 'rev': '206011a8bc5078a02560d5c44177e9849e8f8d6c' })

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:false,
\ 'css': v:false,
\ 'java': v:false,
\ 'go': v:false,
\ 'javascript': v:false,
\ 'nim': v:true,
\ 'python': v:true,
\ 'robo1': v:false,
\ 'shell': v:false,
\ 'typescript': v:true,
\ 'make': v:false,
\ 'vim': v:true,
\}
