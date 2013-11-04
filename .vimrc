syntax enable
set number
set tabstop=2
set shiftwidth=2
set expandtab

set listchars=tab:>-,trail:.,extends:>,precedes:<
set list

set autoindent

" folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
set t_kB=[Z

" setup ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim

set colorcolumn=81
:hi ColorColumn guibg=#AAAAAA ctermbg=254

" ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
" improve autocomplete menu color
highlight Pmenu ctermbg=13 gui=bold

autocmd WinEnter * call Upsize()
autocmd WinLeave * call Equalize()

function! Upsize()
  set winwidth=104
endfunction

function! Equalize()
  set winwidth=24
  exe "normal! \<c-w>="
endfunction

" load pathogen
execute pathogen#infect()

