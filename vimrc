" Pathogen calls
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Personal preferences
colorscheme grb256
set background=dark
set guioptions=-t
syntax on
set nocompatible
set cursorline
filetype plugin indent on
set incsearch
set hidden
set nu
set lines=40
set autoindent
set smartindent
set columns=110
set guifont=Monaco:h13
let mapleader=','
nmap <leader>t :Tlist<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>. :b#<CR>
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
" Set tab behaviour
set ts=4 sts=4 sw=4 noexpandtab

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

 
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
  
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on
   
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
   
  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType html nnoremap <F5> :!open -a Safari %<CR><CR>
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
   
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>w :call HandleURL()<cr>

" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" switch on syntax highlighting
syntax on

" enable filetype detection, plus loading of filetype plugins
filetype plugin on

" Configure browser for haskell_doc.vim
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

" Powerline options
let g:Powerline_symbols = 'fancy'
set laststatus=2
let g:Powerline_theme="default"
let g:Powerline_colorscheme="default"
let g:miniBufExplMapCTabSwitchBufs = 1
