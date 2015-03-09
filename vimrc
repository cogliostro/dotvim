" Pathogen calls
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" Personal preferences
colorscheme atom-dark
" set transparency=0
set background=dark
set encoding=utf-8
set cmdheight=1
let g:netrw_keepdir=0
set guioptions=-t
syntax on
set nocompatible
" set cursorline
filetype plugin indent on
set incsearch
set hidden
set nu
set lines=40
set autoindent
set smartindent
set columns=110
set guifont=Menlo\ for\ Powerline:h11
let mapleader=','
imap <Tab> <Plug>snipMateNextOrTrigger
smap <Tab> <Plug>snipMateNextOrTrigger
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

" Set .tex to latex
let g:tex_flavor='latex'

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on
   
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
   
  " Customisations based on house-style (arbitrary)
  autocmd BufEnter,BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType html nnoremap <F5> :!open -a Safari %<CR><CR>
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType rb setlocal ts=2 sts=2 sw=2 expandtab
  autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
  autocmd FileType eruby.html setlocal ts=2 sts=2 sw=2 expandtab
  
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

" Airline options
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="dark"
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

" vimwiki defaults
let g:vimwiki_list = [{'path':'~/Dropbox/vimwiki', 'path_html':'~/Documents/export/html/'}]
imap <C-j> <Plug>snipMateNextOrTrigger
smap <C-j> <Plug>snipMateNextOrTrigger

