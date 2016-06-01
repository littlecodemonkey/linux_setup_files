set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


syntax on
colorscheme rootwater   					" use this color scheme
set autoread 								" Set to auto read when a file is changed from the outside
set number
set nocompatible
set guifont=Monospace\ 10  					" use this font 
set lines=50       							" height = 50 lines
set columns=150
set selectmode=mouse,key,cmd
set keymodel=
set background=dark     					" adapt colors for background
set nowrap
set tabstop=4       						" numbers of spaces of tab character
set expandtab
set softtabstop=4
set shiftwidth=4
set vb 										" use visual bell instead of beeping
set incsearch 								" incremental search
set title           						" show title in console title bar
set autochdir								" always switch to the current file directory 
set cursorline
set linespace=0
set pastetoggle=<F11> 						" paste mode - this will avoid unexpected pasting effects
set showcmd
set showmatch
set hlsearch        						" highlight searches
set backup
set backupdir = \tmp 				" dir for backup files
set clipboard+=unnamed
set directory = \tmp 				" dir for swp files
set autoindent
set smartindent								" autoindent


" ------ Python settings ------ 
au FileType py set smartindent
au FileType py set cursorline          " highlight current line
au FileType py set textwidth=79        " PEP-8 Friendly


" ------ Perl settings ------ 
" Tidy selected lines (or entire file) with _t:
au FileType perl nnoremap <silent> _t :%!perltidy -q<Enter>
au FileType perl vnoremap <silent> _t :!perltidy -q<Enter>
" Tidy selected lines (or entire file) with _t:
au FileType perl nnoremap <silent> _t :%!perltidy -q<Enter>
au FileType perl vnoremap <silent> _t :!perltidy -q<Enter>
" Deparse obfuscated code
au FileType perl nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
au FileType perl vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>
au FileType perl let perl_include_pod = 1 					" highlight POD correctly:
au FileType perl let perl_extended_vars = 1 					" syntax color complex things like @{${\"foo\"}}


" ------ Putting in augroup makes sure the autocmd only runs once ------
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2

	" check perl code with :make
	autocmd FileType perl set makeprg=perl\ -c\ %\ $*
	autocmd FileType perl set errorformat=%f:%l:%m
	autocmd FileType perl set autowrite	
augroup END


" run script from Vim pressing F5
au FileType perl map <silent> <F5> :!perl ./%<CR>
au FileType python map <silent> <F5> :!python ./%<CR>
au FileType php map <silent> <F5> :!firefox ./%<CR>
au FileType ruby map <silent> <F5> :!ruby ./%<CR>
au FileType sh map <silent> <F5> :!bash ./%<CR>
autocmd FileType java nnoremap <buffer> <F5> :exec '!javac' shellescape(expand('%'), 1) '&& java' shellescape(expand('%:r'), 1)<cr>


" run debugger from Vim pressing F6
au FileType perl map <silent> <F6> :!perl -d:ptkdb ./%<CR>


" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv


" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>


" comment/uncomment blocks of code (in vmode)
vmap _c :s/^/#/gi<Enter>
vmap _C :s/^#//gi<Enter>


" Toggle Relative line numbering on Ctrl-L
function! g:ToggleNuMode() 
if(&rnu == 1) 
set nu 
else 
set rnu 
endif 
endfunc 
nnoremap <C-L> :call g:ToggleNuMode()<cr> 
