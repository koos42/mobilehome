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

colorscheme elflord

" mark the 81st column of text
set colorcolumn=81
:hi ColorColumn guibg=#444444 ctermbg=238

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

" Test helpers from Gary Bernhardt's screen cast:
" https://www.destroyallsoftware.com/screencasts/catalog/file-navigation-in-vim
" https://www.destroyallsoftware.com/file-navigation-in-vim.html
function! RunTests(filename, env_vars)
    " Write the file and run tests for the given filename
    :w

    let is_mix_project = filereadable("./mix.exs")
    let is_elixir = match(a:filename, '_test.exs$') != -1
    let is_python = match(a:filename, '.py$') != -1

    if !is_python
      :silent !echo;echo;echo;
    end

    if is_python
      call Send_to_Tmux("time py.test " . a:filename . "\n")
    elseif is_mix_project
      " cd into app directory one folder above test dir
      let path = split(a:filename, 'test.*')[0]
      let test_file = split(a:filename, l:path)[0]
      exec ":! pushd " . l:path . "; time mix test " . l:test_file . " --trace; popd"
    elseif is_elixir
      exec ":!time elixir " . a:filename
    else
      let rspec_bin = FindRSpecBinary(".")
      exec ":!time NOEXEC=0 " . a:env_vars . rspec_bin . a:filename
    end
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

function! ConditionallySetTestFile()
    let in_spec_file   = match(expand("%"), '_spec.rb$') != -1
    let in_elixir_file = match(expand("%"), '_test.exs$') != -1
    let in_python_test_file = match(expand("%"), 'test.\+\.py$') != -1

    if in_spec_file || in_elixir_file || in_python_test_file
        call SetTestFile()
    end
endfunction

function! RunTestFile(command_suffix, env_vars)
    call ConditionallySetTestFile()

    if !exists("t:grb_test_file")
        exec "!echo 'No test file set'"
        return
    end

    call RunTests(t:grb_test_file . a:command_suffix, a:env_vars)
endfunction

" Bind test runners to keys.
function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number, "")
endfunction
" Run only the example under the cursor
map <leader>. :call RunNearestTest()<cr>

function! RunTestFileWithDebugger()
    call RunTestFile(' -rdebugger', "")
endfunction
map <leader>b :call RunTestFileWithDebugger()<cr>

function! RunNextFailureWithDebugger()
    call RunTests('spec -rdebugger --next-failure', '')
endfunction
map <leader>f :call RunNextFailureWithDebugger()<cr>

function! RunTestFileWithoutDebugger()
    call RunTestFile('', "")
endfunction
" Run this file
map <leader>m :call RunTestFileWithoutDebugger()<cr>

