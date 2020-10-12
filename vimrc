
set nocompatible
set laststatus=2
execute pathogen#infect()
syntax on
filetype plugin indent on
set t_Co=256
set number numberwidth=3
set nocindent autoindent tabstop=4 shiftwidth=4
set conceallevel=2
set noshowmode
colorscheme srcery
let g:lightline = { 'colorscheme': 'srcery', }
set encoding=utf-8 fileencoding=utf-8
set guifont=Fira\ Mono\ 12
set title
set titlestring=%t%a%r%m\ -\ Vim" titlelen=20
set mouse=a

hi SpellBad ctermfg=red
hi SpellBad guisp=red

hi Normal ctermbg=none
hi Folded ctermbg=none
hi htmlBold ctermbg=none
hi htmlItalic ctermbg=none
hi htmlBoldItalic ctermbg=none

" Jump to placeholder: <###>
nnoremap <Leader><Space> <Esc>/<###><CR>"_c5l

" Fix next spell
nnoremap <Leader>s ]s1z=

vnoremap <C-c> "+y
"nnoremap <S-v> "+p
inoremap <C-v> <Esc>"+pi
map <C-a> ggVG

"Splits open at the bottom and right
set splitbelow splitright

" Move lines up or down
nnoremap <C-j> ddp
nnoremap <silent> <C-k> :call MoveLineUp()<CR>

function MoveLineUp()
	" ddP on first and last lines to avoid deleting the line
	if line('.')==1 || line('.')==line('$')
		normal ddP
	else
		normal ddkP
	endif
endfunction

" Find files (:find)
set path+=**
set wildmenu

map <C-n> :NERDTreeToggle<CR>
nnoremap <F3> :Goyo<CR>

autocmd FileType markdown call Markdown()
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4


function Markdown()
	set titlestring=%t%a%r%m\ -\ Vim\ (Markdown)" titlelen=20
	nnoremap <C-p> :call Compile()<CR>
	source ~/.vim/markdown-functions.vim
endfunction


" Compile markdown documents
function Compile()
	:w!
	!compiler %
endfunction

"
" For writing/editing prose
"

nnoremap <F2> :call Writing()<CR>
nnoremap <F4> :call Notes()<CR>
nnoremap <Leader>n :call Notes()<CR>
let s:writingenabled=0
let s:notesenabled=0

function Notes()
  if s:notesenabled
    echo "Epsilon Notes mode disabled"
	setlocal nowrap nospell
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
	let s:notesenabled=0
  else
    echo "Epsilon Notes mode enabled"
    setlocal wrap linebreak nolist spell spelllang=en,es
	"setlocal textwidth=80
	set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
	inoremap !! ¡!<Esc>i
	inoremap ?? ¿?<Esc>i
	inoremap ?! ¡¿?!<Esc>hi
	inoremap << «»<Esc>i

	let s:notesenabled=1
  endif
endfunction

function Writing()
	if s:writingenabled
		echo "Writing mode disabled"
		"Goyo!
		"setlocal noshowmode
		setlocal nospell
		setlocal formatoptions-=a
		setlocal autoindent number
		setlocal textwidth=0
		let s:writingenabled=0
	else
		echo "Writing mode enabled"
		"setlocal showmode
		setlocal formatoptions=ant
		setlocal textwidth=80
		setlocal wrapmargin=0
		setlocal noautoindent "nonumber
		setlocal spell spelllang=en,es
		inoremap !! ¡!<Esc>i
		inoremap ?? ¿?<Esc>i
		inoremap ?! ¡¿?!<Esc>hi
		inoremap << «»<Esc>i
		"Goyo
		let s:writingenabled=1
	endif
endfunction
