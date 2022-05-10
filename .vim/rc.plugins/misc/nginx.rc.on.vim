if InitStep() == 0
  call dein#add('nginx/nginx', { 'rev': '2cb5bdf665c74d09f619add61228e4c3cb626469', 'rtp': 'contrib/vim' })
  finish
endif
