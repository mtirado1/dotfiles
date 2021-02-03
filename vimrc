
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
set whichwrap+=<,>,h,l
hi SpellBad ctermfg=red
hi SpellBad guisp=red

"hi Normal ctermbg=none
"hi Folded ctermbg=none
"hi htmlBold ctermbg=none
"hi htmlItalic ctermbg=none
"hi htmlBoldItalic ctermbg=none

" Fix next spell
nnoremap <Leader>s ]s1z=

vnoremap <C-c> "+y
"nnoremap <S-v> "+p
inoremap <C-v> <Esc>"+pi
map <C-a> ggVG
map <Leader>b :w<CR>:!make<CR>

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

"Find files (:find)
set path+=**
set wildmenu

map <C-n> :NERDTreeToggle<CR>
nnoremap <F3> :Goyo<CR>:set showmode<CR>

autocmd FileType markdown call Markdown()
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

function Markdown()
	nnoremap <C-p> :call Compile()<CR>
	source ~/.vim/markdown-functions.vim
endfunction

" Compile markdown documents
function Compile()
	:w!
	!compiler %
endfunction

