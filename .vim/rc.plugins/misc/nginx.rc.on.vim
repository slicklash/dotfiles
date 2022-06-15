if InitStep() == 0
  call dein#add('nginx/nginx', { 'rev': 'f7e68dba8ca579a3a2357840e827fd598f165ec3', 'rtp': 'contrib/vim' }) "lock-rev
  finish
endif
