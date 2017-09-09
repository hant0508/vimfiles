set nocompatible     	  " отключаем совместимость с vi
set nomodeline
set exrc 			 	  " включаем поддержку локальных .vimrc
set autochdir			  " автоматически переключать рабочую папку
set clipboard=unnamedplus " использовать внешний буфер

set mouse=a				  " включаем мышь
set autoread			  " автоматически перезагружать файл, если он был изменён
set linebreak			  " перенос по словам, а не по буквам
set fileencodings=utf-8,windows-1251	  " подключаем кодировки
set langmap=йцукнгщзфвч.яп;qweryuopadx/zg " включаем поддержку основных команд на русском

set number			" включаем нумерацию строк
set cursorline		" выделяем текущую строку
set showcmd 		" показывать выполняемую команду в правом углу
set ruler			" показывать номер столбца в правом углу
set noshowmode		" не отображать режим ввода (powerline уже делает это красивее)

set wildmenu
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.mp3,*.mp4,*.mkv,*exe,a.out
set scrolloff=5

set ttyfast			" увеличивает производительность (хотя куда уж лучше?)
set lazyredraw		" делает прорисовку плавнее

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

autocmd User Startified setlocal cursorline
let g:startify_enable_special = 0
let g:startify_list_order = [['Recently used files'], 'files',  ['Recently used files in the current directory:'], 'dir']
let g:startify_files_number = 5

" настройки отступов
set cindent			" автоматическая расстановка отступов
set tabstop=4		" длина табуляции по умолчанию
set shiftwidth=4
au BufRead,BufNewFile *.{tex,txt,py,html}	set nocindent
au BufRead,BufNewFile *.{xml,html}			set shiftwidth=2
au BufRead,BufNewFile *.{xml,html}			set tabstop=2
set smarttab		" динамическое изменение длины табуляции

" настройки подсветки синтаксиса
filetype off             
filetype indent plugin on
syntax on
syntax spell toplevel
set t_Co=256
colorscheme night 
autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,hpp,cxx,hxx,cc,java,javascript} call CSyntaxAfter()

" настройки powerline
set laststatus=2
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
		!clang++ -std=c++14 -I. -Wall -lGLU -lGL -lglut "%" && "./a.out"
	elseif expand("%:e")=="c"
		!clang "%" && "./a.out"
	elseif expand("%:e")=="tex"
		!xelatex --8bit  --shell-escape "%" && rm "%:r.log" && (evince "%:r.pdf" &)
	elseif expand("%:e")=="py"
		!python3 "%"
	elseif expand("%:e")=="pas"
		!fpc -oa.out "%" && "./a.out" && rm "%:r.o"
	elseif expand("%:e")=="java"
		!javac "%" && java "%:r" && rm "%:r.class"
	elseif expand("%:e")=="sh"
		!bash "%"
	elseif expand("%:e")=="rb"
		!ruby "%"
	elseif expand("%:e")=="html"
		!(firefox -p test "%" &)
	elseif expand("%:e")=="md"
		!grip -b "%"
	endif
endfunction

function Template() " шаблоны для некоторых языков
	write
	!~/.vim/template.sh %
	edit
endfunction

function Spell() " проверка орфографии
	if &spell
		set nospell
	else
		set spell
		set spelllang=en,ru
		highlight clear SpellBad
		highlight SpellBad ctermfg=Red
		highlight clear SpellCap
		highlight clear SpellLocal
	endif
endfunction

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

com -nargs=1 Item <args>s/^.*/	\\item &  " LaTeX itemize: Item 100,110

" не очищать буфер обмена при выходе
autocmd VimLeave * call system("xsel -ib", getreg('+'))
