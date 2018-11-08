if !dein#tap('vim-quickrun')
    finish
end

let g:quickrun_config['python/test'] = {
  \ 'type': 'python/test',
  \ 'command': 'python3',
  \ 'outputter/buffer/split': 'vert',
  \ 'exec': 'python3 -m unittest -v %s'
  \}
