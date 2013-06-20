" " Maintainer:	Chris Binz
"%
set nocompatible

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

"              OPTIONS
"----------------------------------------
	" GUI OPTIONS
			" toggle toolbar off
			set guioptions-=T
			"default window size
			set lines=66 columns=111
			"colorscheme darkblue
			colorscheme desert
			set t_Co=256
			" guioptions - e for tab pages, g for graying menu items, m for menu bar
			set go=egm
		" match parenthesis
			set showmatch
	" COLORS AND FONT	
			if has("win32")
				set guifont=Consolas:h11:cANSI
			else
				set guifont=Source\ Code\ Pro\ for\ Powerline:h14
			endif
	" SPELLING
			" enable spellcheck
			set spell
			" disable check for capitalization
			set spellcapcheck=""
			" spellfile is local to each file, use this line to set it
			"set spellfile=~/Dropbox/vim/vimfiles/spell/en.latin1.add
"----------------------------------------

"              FOLDING
"----------------------------------------
	" save Foldings automatically -> These are stored in views
	" first specify view dir 
	" notes viewfiles in a	different dir.
	setl viewdir=~/view
	autocmd FileType outliner,vo_base setl viewdir=~/notes/view 	
	au BufWinLeave * silent! mkview
	au BufWinEnter * silent! loadview
"----------------------------------------

"              MAPPINGS
"----------------------------------------
	" make up/down behave
	nnoremap j gj
	nnoremap k gk
	nnoremap gj j
	nnoremap gk k
	" related: enable movement with ALT key while in insert mode
	set winaltkeys=no		" disables menu opening for ALT keys
	inoremap <A-h> <C-o>h
	inoremap <A-j> <C-o>j
	inoremap <A-k> <C-o>k
	inoremap <A-l> <C-o>l
	inoremap <A-w> <C-o>w
	inoremap <A-b> <C-o>b
"----------------------------------------


"              PLUGINS
"----------------------------------------
	" PLUGIN: Pathogen
			" Use pathogen to load plugins from bundle directory
			filetype off
			call pathogen#runtime_append_all_bundles()
			call pathogen#helptags()
			" enable pathogen
			execute pathogen#infect()
	" PLUGIN: vim-notes
			let g:notes_directories= ['~/notes']
			let g:notes_suffix='.txt'
	" PLUGIN: vim-links
			" add one of these for each file type you want vim-links to be active
			" NOTE: make sure these lines appear after other syntax is set in .vimrc (i.e.
			" after `syntax on`
			autocmd FileType vo_base setlocal ft+=.links
	" PLUGIN: NERDTree
			" Map :NERDTree command to <leader>N
			noremap <leader>N :NERDTree<CR>
	" PLUGIN: Powerline
			set laststatus=2	" Always display the statusline
			set noshowmode		" Hide the default mode text
			if has("win32") || has("win64")
				set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
			else
				python from powerline.vim import setup as powerline_setup
				python powerline_setup()
				python del powerline_setup
				set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
			endif
	" PLUGIN: vim-latex
			" IMPORTANT: grep will sometimes skip displaying the file name if you
			" search in a singe file. This will confuse Latex-Suite. Set your grep
			" program to always generate a file-name.
			set grepprg=grep\ -nH\ $*
			" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
			" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
			" The following changes the default filetype back to 'tex':
			let g:tex_flavor='latex'
			" PDF viewer (other OS's should work by default)
			if has("win32") || has("win64")
				let g:Tex_ViewRule_pdf='C:\Program Files (x86)\SumatraPDF\SumatraPDF'
			endif
			" Suppress all warnings below level 4
			let g:TCLevel = 4
			" Make LaTeX-suite stop opening files with errors
			" automatically
			let g:Tex_GotoError=0
	" PLUGIN: vim-outliner
			"allow hoisting
			let g:vo_modules_load="checkbox:hoist"
			let maplocalleader= ",,"
"----------------------------------------

"           FILE MANAGEMENT
"----------------------------------------
		" specify where viminfo should be pulled from
		" viminfo is where marks are stored
		set viminfo='1000,<50,s10,h,rA:,rB:,n~/notes/.viminfo
		" change backup/swap file directory
		if has("win32") || has("win64")
			 set directory=$TMP
		else
			set directory=/tmp
		end
"----------------------------------------

"               OTHER
"----------------------------------------
		" use conceal
		set conceallevel=2 "level 2 = hide, don't replace with any character
		set concealcursor=nc	"define when to hide concealed text, 'nc' is in normal and command line mode
		" allow backspacing over everything in insert mode
		set backspace=indent,eol,start
"----------------------------------------

"          BOILERPLATE/DEFAULTS
"----------------------------------------
		if has("vms")
			set nobackup		" do not keep a backup file, use versions instead
		else
			set backup		" keep a backup file
		endif
		set history=50		" keep 50 lines of command line history
		set ruler		" show the cursor position all the time
		set showcmd		" display incomplete commands
		set incsearch		" do incremental searching

		" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
		" let &guioptions = substitute(&guioptions, "t", "", "g")

		" Don't use Ex mode, use Q for formatting
		map Q gq

		" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
		" so that you can undo CTRL-U after inserting a line break.
		inoremap <C-U> <C-G>u<C-U>

		" In many terminal emulators the mouse works just fine, thus enable it.
		if has('mouse')
			set mouse=a
		endif


		" Only do this part when compiled with support for autocommands.
		if has("autocmd")

			" Enable file type detection.
			" Use the default filetype settings, so that mail gets 'tw' set to 72,
			" 'cindent' is on in C files, etc.
			" Also load indent files, to automatically do language-dependent indenting.
			filetype plugin indent on

			" Put these in an autocmd group, so that we can delete them easily.
			augroup vimrcEx
			au!

			" For all text files set 'textwidth' to 78 characters.
			autocmd FileType text setlocal textwidth=78

			" When editing a file, always jump to the last known cursor position.
			" Don't do it when the position is invalid or when inside an event handler
			" (happens when dropping a file on gvim).
			" Also don't do it when the mark is in the first line, that is the default
			" position when opening a file.
			autocmd BufReadPost *
				\ if line("'\"") > 1 && line("'\"") <= line("$") |
				\   exe "normal! g`\"" |
				\ endif

			augroup END

		else

			set autoindent		" always set autoindenting on

		endif " has("autocmd")

		" Convenient command to see the difference between the current buffer and the
		" file it was loaded from, thus the changes you made.
		" Only define it when not defined already.
		if !exists(":DiffOrig")
			command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
					\ | wincmd p | diffthis
		endif
"----------------------------------------
