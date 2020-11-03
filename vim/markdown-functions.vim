" Markdown editing functions
" Most of this code was taken from https://github.com/plasticboy/vim-markdown

" Automatically continue blockquote on line break
setlocal formatoptions+=r
setlocal comments=b:>
if get(g:, "vim_markdown_auto_insert_bullets", 1)
    " Do not automatically insert bullets when auto-wrapping with text-width
    setlocal formatoptions-=c
    " Accept various markers as bullets
    setlocal comments+=b:*,b:+,b:-,b:;
endif

" Open files/links
nnoremap <C-l> ?[<CR>/(<CR> gf

"
" Depends on Tabularize.
"
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
		if empty(matchstr(l, '^#\+')) && empty(matchstr(l, '^@@')) && empty(matchstr(l, '^---$'))
			let wc += len(split(l, ' '))
		endif
	endfor
	let expansionString = repeat(".", w)
    let header = getline(v:foldstart)
	let txt = repeat("    ", len(matchstr(header, '^#\+')) - 1) . header . " (" . wc . " words)" . expansionString 
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

let s:allfold=0
function! ToggleFold()
	if s:allfold
		normal zR
		let s:allfold=0
	else
		normal zM
		let s:allfold=1
	endif
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

" Tab to toggle header fold
nnoremap <Tab> za
" Shift+Tab to toggle all folds
nnoremap <silent> <S-Tab> :call ToggleFold()<CR>

" make word bold
inoremap <C-b> <Esc>viwc**<C-r>"**
nnoremap <C-b> viwc**<C-r>"**<Esc>
" Make selection bold
vnoremap <C-b> c**<C-r>"**<Esc>

set foldexpr=MarkdownLevel()
set foldmethod=expr
set foldtext=MyFoldText()
normal zR
