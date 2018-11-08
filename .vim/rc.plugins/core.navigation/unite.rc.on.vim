if InitStep() == 0
  call dein#add('Shougo/unite.vim')
  let g:unite_source_menu_menus = {}
  finish
endif

let g:unite_prompt = '» '
let g:unite_update_time = 200
let g:unite_source_rec_max_cache_files = 5000
let g:unite_source_history_yank_enable = 1
let g:unite_data_directory = $HOME.'/.vim/cache/unite'

call unite#custom#profile('default', 'context', {
    \ 'start_insert' : has('nvim') ? 0 : 1,
    \ 'short_source_names' : 1
    \ })

if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
endif

" nnoremap <Space>b :Unite -buffer-name=buffer buffer<CR>
" nnoremap <Space>r :Unite -buffer-name=mru file_mru<CR>
" nnoremap <Space>f :Unite -buffer-name=files file_rec/async:!<CR>
" nnoremap <Space>d :Unite -buffer-name=files file<CR>
" nnoremap <Space>h :Unite history/unite<CR>
" nnoremap <Space>/ :Unite grep:.<CR>
" nnoremap <Space>s :Unite -buffer-name=search line:all<CR>

function! s:unite_my_settings() abort

    nmap <buffer> <ESC> <Plug>(unite_exit)
    imap <buffer> <ESC> <Plug>(unite_exit)

    " imap <buffer> <Tab> <Plug>(unite_complete)
    imap <buffer> jj    <Plug>(unite_insert_leave)
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)
    imap <buffer> <C-a> <Plug>(unite_choose_action)

    " nnoremap <silent> <buffer> <expr> <C-i> unite#do_action('above')
    " inoremap <silent> <buffer> <expr> <C-i> unite#do_action('above')
    "
    " nnoremap <silent> <buffer> <expr> <C-m> unite#do_action('below')
    " inoremap <silent> <buffer> <expr> <C-m> unite#do_action('below')
    "
    " nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('right')
    " inoremap <silent> <buffer> <expr> <C-l> unite#do_action('right')
    "
    " nnoremap <silent> <buffer> <expr> <C-h> unite#do_action('left')
    " inoremap <silent> <buffer> <expr> <C-h> unite#do_action('left')

    imap <buffer> '          <Plug>(unite_quick_match_default_action)
    nmap <buffer> '          <Plug>(unite_quick_match_default_action)
    nmap <buffer> cd         <Plug>(unite_quick_match_default_action)

    nnoremap <silent><buffer><expr> l
            \ unite#smart_map('l', unite#do_action('default'))
    nnoremap <silent><buffer><expr> P
            \ unite#smart_map('P', unite#do_action('insert'))

    nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
    nnoremap <silent><buffer><expr> ! unite#do_action('start')

    let unite = unite#get_current_unite()

    if unite.profile_name ==# '^search'
        nnoremap <silent><buffer><expr> r unite#do_action('replace')
    else
        nnoremap <silent><buffer><expr> r unite#do_action('rename')
    endif

endfunction

autocmd FileType unite call s:unite_my_settings()
