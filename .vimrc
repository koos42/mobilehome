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

" Use comma for Leader (easier to type than backslash)
let mapleader = ","

nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
set t_kB=[Z

" setup ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$|bundle|vendor',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }

" mark the 81st column of text
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

" remove trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" System Yank: will copy into the system clipboard on OS X
vmap sy :w !pbcopy<CR><CR>


" RSpec test helpers.
" Originals from Gary Bernhardt's screen cast:
" https://www.destroyallsoftware.com/screencasts/catalog/file-navigation-in-vim
" https://www.destroyallsoftware.com/file-navigation-in-vim.html
" Modified by Myron Marston:
" https://github.com/myronmarston/vim_files
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    let rspec_bin = FindRSpecBinary(".")
    exec ":!time NOEXEC=0 " . rspec_bin . a:filename " --backtrace"
endfunction

function! FindRSpecBinary(dir)
  if filereadable(a:dir . "/bin/rspec")
    return a:dir . "/bin/rspec "
  elseif filereadable(a:dir . "/.git/config")
    " If there's a .git/config file, assume it is the project root;
    " Just run the system-gem installed rspec binary.
    return "rspec "
  else
    " We may be in a project sub-dir; check our parent dir
    return FindRSpecBinary(a:dir . "/..")
  endif
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

" Run this file
map <leader>m :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>. :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>
