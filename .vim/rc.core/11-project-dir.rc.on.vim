augroup ft_proj
  autocmd!
  autocmd FileType * call s:project_dir()
augroup END

function! s:project_dir() abort
  let cwd = expand('%:p')
  if cwd =~? 'code/app-market/communities'
    let b:project_dir='/home/slicklash/code/app-market/communities'
  elseif cwd =~? 'bookings-booking-checkout-owner'
    let b:project_dir='/home/slicklash/code/bookings/bookings-booking-checkout-owner'
  elseif cwd =~? 'bookings-calendar-catalog-owner'
    let b:project_dir='/home/slicklash/code/bookings/bookings-calendar-catalog-owner'
  endif
endfunction
