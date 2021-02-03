" Markdown editing functions
" Most of this code was taken from https://github.com/plasticboy/vim-markdown

" Automatically continue blockquote on line break
setlocal formatoptions+=r
setlocal comments=b:>,b:@@
if get(g:, "vim_markdown_auto_insert_bullets", 1)
    " Do not automatically insert bullets when auto-wrapping with text-width
    setlocal formatoptions-=c
    " Accept various markers as bullets
    setlocal comments+=b:*,b:+,b:-,b:;
endif


" Depends on Tabularize.
function! s:TableFormat()
    let l:pos = getpos('.')
    normal! {
    " Search instead of `normal! j` because of the table at beginning of file edge case.
    call search('|')
    normal! j
    " Remove everything that is not a pipe, colon or hyphen next to a colon othewise
    " well formated tables would grow because of addition of 2 spaces on the separator
    " line by Tabularize /|.
    let l:flags = (&gdefault ? '' : 'g')
    execute 's/\(:\@<!-:\@!\|[^|:-]\)//e' . l:flags
    execute 's/--/-/e' . l:flags
    Tabularize /|
    " Move colons for alignment to left or right side of the cell.
    execute 's/:\( \+\)|/\1:|/e' . l:flags
    execute 's/|\( \+\):/|:\1/e' . l:flags
    execute 's/ /-/' . l:flags
    call setpos('.', l:pos)
endfunction

command! -buffer TableFormat call s:TableFormat()

" Folds headers and gives a wordcount
" ignores contained headers and comments (lines starting with @@)
function! MyFoldText()
    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
	let wc = 0
	" Count words
	for l in getline(v:foldstart + 1, v:foldend)
		" Ignore headers and comments
		if empty(matchstr(l, '^#\+')) && empty(matchstr(l, '^@@ ')) && empty(matchstr(l, '^---$'))
			let wc += len(split(l, ' '))
		endif
	endfor
	let expansionString = repeat(".", w)
	let level = len(matchstr(getline(v:foldstart), '^#\+')) - 1
    let header = repeat('│ ', level) . substitute(getline(v:foldstart), '^#\+', "•", "")
	let txt = header . repeat(' ', 45 - strwidth(header)) . "(" . wc . " words)" . expansionString 
    return txt
endfunction

function! PromoteElement()
	let line = getline('.')
	let h = matchstr(line, '^#\+')
	if !empty(h) && (len(h) > 1)
		normal 0x
	endif
	let h = matchstr(line, '^\s*\%([;*-+]\|[0-9]\+[;\.] \)')
	if !empty(h) && len(matchstr(line, '^\s*')) >= 4
		normal 0w4X
	endif
endfunction

function! DemoteElement()
	let line = getline('.')
	let h = matchstr(line, '^#\+')
	if !empty(h) && (len(h) < 6)
		normal 0i#
		return
	endif
	let h = matchstr(line, '^\s*\%([;*-+]\|[0-9]\+[;\.] \)')
	if !empty(h)
		normal I    
	endif
endfunction

let b:allfold = 0
function! ToggleFold()
	if b:allfold
		normal zR
	else
		normal zM
	endif
	let b:allfold = !b:allfold
endfunction


function! MarkdownLevel()
	let h = matchstr(getline(v:lnum), '^#\+')
	if empty(h)
		return "="
	else
		return ">" . len(h)
	endif
endfunction

" Promote/Demote header and list elements
nnoremap <silent> <C-l> :call DemoteElement()<CR>
nnoremap <silent> <C-h> :call PromoteElement()<CR>
" Format tables
nnoremap <Leader>t :TableFormat<CR>
" Jump to [placeholder]
nnoremap <Leader><Space> <Esc>/\[*\]<CR>va[
vnoremap <Leader><Space> <Esc>/\[*\]<CR>va[

" make word bold
inoremap <C-b> <Esc>viWc**<C-r>"**
nnoremap <C-b> viWc**<C-r>"**<Esc>
" Make selection bold
vnoremap <C-b> c**<C-r>"**<Esc>

" Fold
set foldexpr=MarkdownLevel()
set foldmethod=expr
set foldtext=MyFoldText()
" Tab to toggle header fold
nnoremap <Tab> za
" Shift+Tab to toggle all folds
nnoremap <silent> <S-Tab> :call ToggleFold()<CR>
normal zR

" General shortcurs for spanish prose
inoremap !! ¡!<Esc>i
inoremap ?? ¿?<Esc>i
inoremap ?! ¡¿?!<Esc>hi
inoremap << «»<Esc>i

" Hard wrap prose
let b:writingenabled=0
nnoremap <F2> :call Writing()<CR>

function Writing()
	setlocal spell!
	if b:writingenabled
		echo "Writing mode disabled"
		setlocal formatoptions-=ant
		setlocal textwidth=0
	else
		echo "Writing mode enabled"
		setlocal formatoptions+=ant
		setlocal textwidth=80
		setlocal wrapmargin=0
		setlocal spelllang=en,es
	endif
	let b:writingenabled = !b:writingenabled
endfunction


" Soft wrap prose
nnoremap <F4> :call Notes()<CR>
let b:notesenabled=0

function Notes()
  if b:notesenabled
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

  endif
    let b:notesenabled = !b:notesenabled
endfunction


