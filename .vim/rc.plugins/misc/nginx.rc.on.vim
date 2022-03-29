if InitStep() == 0
  call dein#add('nginx/nginx', { 'rev': '828fb94e1dbe1c433edd39147ba085c4622c99ed', 'rtp': 'contrib/vim' })
  finish
endif
