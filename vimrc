" Pathogen calls
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Personal preferences
colorscheme grb256
set background=dark
set encoding=utf-8
set cmdheight=1
let g:netrw_keepdir=0
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
set guifont=Monaco\ for\ Powerline:h11
let mapleader=','
nmap <leader>a :EasyAlign<CR>
vmap <leader>a :EasyAlign!<CR>
nmap <leader>t :Tlist<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>. :b#<CR>
map <C-Tab> :bn<cr>
map <S-C-Tab> :bp<cr>
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"

" Set backupdir to .backup
set backupdir=~/.backup,.
set directory=~/.backup,.
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
  autocmd BufEnter,BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType hs setlocal ts=4 sts=4 sw=4 expandtab smarttab shiftround nojoinspaces
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType html nnoremap <F5> :!open -a Safari %<CR><CR>
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType rb setlocal ts=2 sts=2 sw=2 expandtab
  autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
  autocmd FileType eruby.html setlocal ts=2 sts=2 sw=2 expandtab
  
  " Haskell customization
  autocmd FileType haskell setlocal ts=8 expandtab sts=4 sw=4 smarttab shiftround nojoinspaces
  autocmd FileType haskell nmap <C-c><C-l> :GhciRange<CR>
  autocmd FileType haskell vmap <C-c><C-l> :GhciRange<CR>
  autocmd FileType haskell nmap <C-c><C-f> :GhciFile<CR>
  autocmd FileType haskell nmap <C-c><C-r> :GhciReload<CR>


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

" Configure browser for haskell_doc.vim
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s -a Firefox %s"

"
" Haskell settings
"

let s:width = 80

function! HaskellModuleSection(...)
    let name = 0 < a:0 ? a:1 : inputdialog("Section name: ")

    return  repeat('-', s:width) . "\n"
    \       . "--  " . name . "\n"
    \       . "\n"

endfunction

nmap <silent> --s "=HaskellModuleSection()<CR>gp

let s:width = 80


function! HaskellModuleHeader(...)
    let name = 0 < a:0 ? a:1 : inputdialog("Module: ")
    let note = 1 < a:0 ? a:2 : inputdialog("Note: ")
    let description = 2 < a:0 ? a:3 : inputdialog("Describe this module: ")
    
    return  repeat('-', s:width) . "\n" 
    \       . "-- | \n" 
    \       . "-- Module      : " . name . "\n"
    \       . "-- Note        : " . note . "\n"
    \       . "-- \n"
    \       . "-- " . description . "\n"
    \       . "-- \n"
    \       . repeat('-', s:width) . "\n"
    \       . "\n"

endfunction


nmap <silent> --h "=HaskellModuleHeader()<CR>:0put =<CR>

let g:ghcmod_ghc_options = ['-fno-warn-type-defaults']

" Airline options
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="powerlineish"
let g:airline#extensions#syntastic#enabled = 1

nnoremap <leader>h :!open %<CR><CR>

autocmd BufWriteCmd *.html,*.css,*.gtpl :call Refresh_firefox()
function! Refresh_firefox()
  if &modified
    write
    silent !echo  'vimYo = content.window.pageYOffset;
          \ vimXo = content.window.pageXOffset;
          \ BrowserReload();
          \ content.window.scrollTo(vimXo,vimYo);
          \ repl.quit();'  |
          \ nc -w 1 localhost 4242 2>&1 > /dev/null
  endif
endfunction

" Synastic defaults
let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['pep8']

autocmd FileType haskell nmap <C-c><C-l> :GhciRange<CR>
autocmd FileType haskell vmap <C-c><C-l> :GhciRange<CR>
autocmd FileType haskell nmap <C-c><C-f> :GhciFile<CR>
autocmd FileType haskell nmap <C-c><C-r> :GhciReload<CR>
