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
      \ 'short_source_names': v:true
      \ })

call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-a>', '<denite:choose_action>', 'noremap')
call denite#custom#map('insert', '<C-l>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('insert', '<C-m>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<C-t>', '<denite:do_action:tabopen>', 'noremap')
call denite#custom#map('normal', '<C-q>', '<denite:do_action:quickfix>', 'noremap')
call denite#custom#map('normal', '<C-s>', '<denite:toggle_select_all>', 'noremap')
call denite#custom#map('insert', '<CR>', '<denite:do_action:default>', 'noremap')

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
nnoremap <Space>/ :Denite -buffer-name=grep -no-quit -direction=botright grep<CR>
nnoremap <Space>D :DeniteBufferDir -buffer-name=dir file/rec -matchers=matcher_substring<CR>
nnoremap <Space>d :DeniteBufferDir -buffer-name=dir file/rec<CR>
nnoremap <Space>h :Denite -buffer-name=help help<CR>

nnoremap <Space>a :Denite -buffer-name=communities file/rec:~/code/app-market/communities<CR>
nnoremap <Space>A :Denite -buffer-name=communities -direction=botright grep:~/code/app-market/communities<CR>

nnoremap <Leader>fd :Denite -buffer-name=grepl -direction=botright grep:::`expand('<cword>')`<CR>


