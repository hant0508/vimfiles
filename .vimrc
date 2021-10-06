set nocompatible     	  " отключаем совместимость с vi
set nomodeline
set autochdir			  " автоматически переключать рабочую папку
set clipboard=unnamedplus " использовать внешний буфер

set mouse=a				  " включаем мышь
set autoread			  " автоматически перезагружать файл, если он был изменён
set linebreak			  " перенос по словам, а не по буквам
set fileencodings=utf-8,windows-1251	  " подключаем кодировки
set langmap=йцукнгщзфвчяпО;qweryuopadxzgJ " включаем поддержку основных команд на русском

set number			" включаем нумерацию строк
set cursorline		" выделяем текущую строку
set showcmd 		" показывать выполняемую команду в правом углу
set ruler			" показывать номер столбца в правом углу
set noshowmode		" не отображать режим ввода (powerline уже делает это красивее)

set wildmenu
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.mp3,*.mp4,*.mkv,*exe,*.pdf,*.aux,*.o
set scrolloff=5

set ttyfast	" делает прорисовку плавнее
au BufRead,BufNewFile * set lazyredraw

set noswapfile		" отключаем swap-файлы
set undofile		" и подключаем вместо них undo
set undolevels=1000
set undoreload=10000
set undodir=~/.vim/undo

" перемещение по длинным строкам и быстрый ввод команд
map <Up> gk
imap <Up> <C-O>gk
map <Down> gj
imap <Down> <C-O>gj
map j gj
map k gk
nnoremap ; :

if getcwd()!="/home/hant0508/git/tmp" &&  getcwd()!="/home/hant0508/git/lessons"
	set exrc   " включаем поддержку локальных .vimrc
endif

autocmd User Startified setlocal cursorline
let g:startify_enable_special = 0
let g:startify_list_order = [['Recently used files'], 'files',  ['Recently used files in the current directory:'], 'dir']
let g:startify_files_number = 5

" настройки отступов
filetype plugin indent on
set tabstop=4		" длина табуляции по умолчанию
set shiftwidth=4
au BufRead,BufNewFile *.{tex,txt,py,html}	set noautoindent
au BufRead,BufNewFile *.{tex,xml,html,css}	set shiftwidth=2
au BufRead,BufNewFile *.{tex,xml,html,css}	set tabstop=2
" au BufRead,BufNewFile *.{c}	set expandtab
set smarttab		" динамическое изменение длины табуляции

" настройки подсветки синтаксиса
syntax on
syntax spell toplevel
set t_Co=256
colorscheme night
autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,hpp,cxx,hxx,cc,java,javascript} call CSyntaxAfter()
au BufRead,BufNewFile *.{s,asm,inc,nasm} set ft=nasm
au BufRead,BufNewFile *.{scm} set ft=racket
let g:python_highlight_all = 1

" настройки powerline
set laststatus=2
set ttimeoutlen=10 " убирает задержку при выходе из режима вставки
let g:airline_powerline_fonts=1
let g:airline_detect_whitespace=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2

" у вима есть 2 режима работы: в одном он бибикает, в другом - всё портит (с)
" проблема с бибиканьем оказалась решаема
set noerrorbells
set visualbell
set t_vb=

function! Run() " расширяем и без того безграничные возможности F5
	if expand("%:e")=="cpp"
		!g++ -std=c++17 -I. -O0 -Wall -Wextra -pthread "%" && "./a.out"
	elseif expand("%:e")=="c"
		!gcc -O2 -Wall -Wno-pointer-sign -std=gnu11 "%" -lm && "./a.out"
	elseif expand("%:e")=="tex"
		!xelatex --8bit  --shell-escape "%" && rm "%:r.log" && (evince "%:r.pdf" 2> /dev/null &)
"		!pdflatex "%" && rm "%:r.log" && (evince "%:r.pdf" 2> /dev/null &)
	elseif expand("%:e")=="xtex"
		!xelatex --8bit  --shell-escape "%" && rm "%:r.log" && (evince "%:r.pdf" 2> /dev/null &)
	elseif expand("%:e")=="py"
		!python3 "%"
	elseif expand("%:e")=="go"
		!go fmt "%" && go run "%"
	elseif expand("%:e")=="pas"
		!fpc -oa.out "%" && "./a.out" && rm "%:r.o"
	elseif expand("%:e")=="java"
		!javac "%" && java "%:r" && rm "%:r.class"
	elseif expand("%:e")=="sh"
		!bash "%"
	elseif expand("%:e")=="rb"
		!ruby "%"
	elseif expand("%:e")=="scm"
		!racket "%"
	elseif expand("%:e")=="rkt"
		!racket "%"
	elseif expand("%:e")=="html"
		!(firefox -p test "%" &)
	elseif expand("%:e")=="md"
		!grip -b "%"
	elseif expand("%:e")=="s"
		!~/.vim/build_asm.sh "%" "%:p:h"
	elseif expand("%:e")=="asm"
		!~/.vim/build_asm.sh "%" "%:p:h"
	endif
endfunction

function Template() " шаблоны для некоторых языков
	write
	!~/.vim/template.sh %
	edit
endfunction

" проверка орфографии
set nospell
set spelllang=en,ru

function Spell() " включение/выключение проверки
	if &spell
		set nospell
		call cursor(line('.'), col('.')-1) " чтобы курсор не убегал
	else
		set spell
		syntax spell toplevel
		highlight clear SpellBad " подсветка ошибок
		highlight SpellBad ctermfg=Red
		highlight clear SpellCap
		highlight clear SpellLocal
		call cursor(line('.'), col('.')-1)
	endif
endfunction

function ToggleLight()
	if exists("g:lucius_style")
		color night
		let g:airline_theme="dark"
		AirlineRefresh
		unlet g:lucius_style
	else
		let g:lucius_style="light"
		let g:lucius_contrast="high"
		let g:lucius_contrast_bg="high"
		color lucius
	endif
endfunction

command Light call ToggleLight()

function Tex()
	set tw=80
	set fo+=t
	set ft=tex
	call Spell()
endfunction
au BufRead,BufNewFile *.{tex,xtex}	call Tex()

map <F4> :NERDTreeToggle<CR>
map <F5> :call Run()<CR>
map <F6> :call Template()<CR><CR>
map <F7> :!~/.vim/test.sh<CR>
map <F8> :!make run<CR>
map <F9> :!make debug<CR>
map <F10> :call Spell()<CR>

" отключаем справку по F1 и 'расширяем' Esc
map <F1> <Esc>
imap <F1> <Esc>

" LaTeX itemize: Item 100,110
com -nargs=1 Item <args>s/^.*/	\\item &

" не очищать буфер обмена при выходе
autocmd VimLeave * call system("xsel -ib", getreg('+'))

" сохранить из-под sudo
cmap w!! w !sudo tee > /dev/null %

nnoremap g<Left> gT
nnoremap g<Right> gt

let g:AutoPairsMultilineClose = 0
let g:AutoPairsFlyMode = 0

set foldmethod=indent
set foldlevelstart=99
set nofoldenable
