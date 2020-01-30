if InitStep() == 0
  call dein#add('Shougo/denite.nvim')
  let g:denite_source_menu_menus = {}
  finish
endif

scriptencoding utf-8

call denite#custom#option('_', {
      \ 'prompt': '» ',
      \ 'direction': 'topleft',
      \ 'highlight_matched_char' : 'MenuMatch',
      \ 'highlight_matched_range' : 'None',
      \ 'highlight_mode_insert' : 'MenuSel',
      \ 'short_source_names': v:true,
      \ 'start_filter': v:true,
      \ })

function! s:denite_quickfix()
  call denite#call_map('toggle_select_all')
  call denite#call_map('do_action', 'quickfix')
endfunction

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> a denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> <C-s>
        \ denite#do_map('toggle_select_all')
  nnoremap <silent><buffer><expr> <C-q>
        \ denite#do_map('do_action', 'quickfix')
  nnoremap <silent><buffer> <C-b>
        \ :<C-u>call <SID>denite_quickfix()<CR>
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> <C-l> denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-m> denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabopen')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  call deoplete#custom#buffer_option('auto_complete', v:false)
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  inoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-l> denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-m> denite#do_map('do_action', 'split')
  inoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabopen')
endfunction

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/'])

function! s:get_rg_options(ignore)
  let l:rg_options = ['rg', '--files', '--hidden', '--no-ignore-vcs']
  for l:item in a:ignore
    call extend(l:rg_options, ['--glob', '!' . l:item])
  endfor
  return l:rg_options
endfunction

call denite#custom#alias('source', 'file_rec/config', 'file/rec')
call denite#custom#alias('source', 'file_rec/zsh', 'file/rec')
call denite#custom#alias('source', 'file_rec/all', 'file/rec')

if executable('rg')
  call denite#custom#var('file/rec', 'command', s:get_rg_options(['.git', '__pycache__', 'node_modules', 'target', 'dist']))
  call denite#custom#var('file_rec/config', 'command', s:get_rg_options(['.denite', '.cache', 'cache', 'repos', '.dein']))

  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

nnoremap <Space>c :Denite -buffer-name=files file_rec/config:~/.vim<CR>
nnoremap <Space>z :Denite -buffer-name=files file_rec/zsh:~/.zsh<CR>
nnoremap <Space>B :Denite -buffer-name=buffer buffer -matchers=matcher_substring<CR>
nnoremap <Space>b :Denite -buffer-name=buffer buffer<CR>
nnoremap <Space>R :Denite -buffer-name=mru -statusline=false file_mru -matchers=matcher_substring<CR>
nnoremap <Space>r :Denite -buffer-name=mru -statusline=false file_mru<CR>
nnoremap <Space>F :Denite -buffer-name=files file/rec -matchers=matcher_substring<CR>
nnoremap <Space>f :Denite -buffer-name=files file/rec<CR>
nnoremap <Space>/ :Denite -buffer-name=grep -direction=botright grep<CR>
nnoremap <Space>D :DeniteBufferDir -buffer-name=dir file/rec -matchers=matcher_substring<CR>
nnoremap <Space>d :DeniteBufferDir -buffer-name=dir file/rec<CR>
nnoremap <Space>h :Denite -buffer-name=help help<CR>

nnoremap <Space>a :Denite -buffer-name=communities file/rec:~/code/app-market/communities<CR>
nnoremap <Space>A :Denite -buffer-name=communities -direction=botright grep:~/code/app-market/communities<CR>

nnoremap <Leader>fd :Denite -buffer-name=grepl -direction=botright grep:::`expand('<cword>')`<CR>
