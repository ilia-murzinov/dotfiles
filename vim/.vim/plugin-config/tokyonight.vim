try
  if has('nvim')
    colorscheme tokyonight-night
  else
    let g:tokyonight_style = 'night'
    let g:tokyonight_enable_italic = 0
    colorscheme tokyonight
  endif
catch
  colorscheme desert
endtry
highlight ColorColumn ctermbg=0 guibg=#414868
