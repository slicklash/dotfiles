if InitStep() == 0
  call dein#add('nginx/nginx', { 'rtp': 'contrib/vim' })
  finish
endif
