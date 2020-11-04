
set nocompatible
set laststatus=2
execute pathogen#infect()
syntax on
filetype plugin indent on
set t_Co=256
set cursorline number numberwidth=3
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

" Soft wrap prose
function Notes()
  if s:notesenabled
    echo "Notes mode disabled"
	setlocal wrap nospell nolinebreak
    silent! nunmap <buffer> 0
    silent! nunmap <buffer> $
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! iunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
	let s:notesenabled=0
  else
    echo "Notes mode enabled"
    setlocal wrap linebreak spell spelllang=en,es
    setlocal display+=lastline
	noremap  <buffer> <silent> 0 g0
	noremap  <buffer> <silent> $ g$
	noremap  <buffer> <silent> j gj
	noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
	inoremap !! ¡!<Esc>i
	inoremap ?? ¿?<Esc>i
	inoremap ?! ¡¿?!<Esc>hi
	inoremap << «»<Esc>i

	let s:notesenabled=1
  endif
endfunction

" Hard wrap prose
function Writing()
	setlocal spell!
	if s:writingenabled
		echo "Writing mode disabled"
		setlocal formatoptions-=a
		setlocal textwidth=0
		let s:writingenabled=0
	else
		echo "Writing mode enabled"
		setlocal formatoptions+=ant
		setlocal textwidth=80
		setlocal wrapmargin=0
		setlocal spelllang=en,es
		inoremap !! ¡!<Esc>i
		inoremap ?? ¿?<Esc>i
		inoremap ?! ¡¿?!<Esc>hi
		inoremap << «»<Esc>i
		let s:writingenabled=1
	endif
endfunction
