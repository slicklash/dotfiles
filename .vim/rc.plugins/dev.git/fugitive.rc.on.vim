if InitStep() == 0
  call dein#add('tpope/vim-fugitive')
  finish
endif

autocmd BufReadPost fugitive://* set bufhidden=delete

if !dein#tap('unite.vim')
  finish
endif

let g:unite_source_menu_menus.git = {
      \ 'description' : 'Fugitive interface',
      \}

let g:unite_source_menu_menus.git.command_candidates = [
      \[' git status', 'Gstatus'],
      \[' git diff', 'Gvdiff'],
      \[' git commit', 'Gcommit'],
      \[' git stage/add', 'Gwrite'],
      \[' git checkout', 'Gread'],
      \[' git rm', 'Gremove'],
      \[' git cd', 'Gcd'],
      \[' git push', 'exe "!git push"'],
      \[' git push branch', 'exe "Git! push -u origin " input("branch: ")'],
      \[' git pull', 'exe "!git pull --rebase"'],
      \[' git pull branch', 'exe "Git! pull " input("branch: ")'],
      \[' git fetch', 'Gfetch'],
      \[' git merge', 'Gmerge'],
      \[' git browse', 'Gbrowse'],
      \[' git head', 'Gedit HEAD^'],
      \[' git parent', 'edit %:h'],
      \[' git log commit buffers', 'Glog --'],
      \[' git log current file', 'Glog -- %'],
      \[' git log last n commits', 'exe "Glog -" input("num: ")'],
      \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
      \[' git log until date', 'exe "Glog --until=" input("day: ")'],
      \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
      \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
      \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
      \[' git mv', 'exe "Gmove " input("destination: ")'],
      \[' git grep',  'exe "Ggrep " input("string: ")'],
      \[' git prompt', 'exe "Git! " input("command: ")'],
      \]
nnoremap <silent> <Space>g :Unite -vertical -silent -buffer-name=git menu:git<CR>

nnoremap <silent> <leader>gg :Gstatus<cr>
nnoremap <silent> <leader>gb :Gblame<CR>
" nnoremap <silent> <leader>gk :Git push<cr>
" nnoremap <silent> <leader>gj :Git pull<cr>
" nnoremap <silent> <leader>gl :Glog -10<cr>
" nnoremap <silent> <leader>gd :Gdiff<CR>
" nnoremap <silent> <leader>gc :Gcommit<CR>
" nnoremap <silent> <leader>gw :Gwrite<CR>
" nnoremap <silent> <leader>gr :Gremove<CR>
