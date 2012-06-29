syntax enable
set number
set tabstop=2
set shiftwidth=2
set expandtab

set autoindent

nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
set t_kB=[Z
