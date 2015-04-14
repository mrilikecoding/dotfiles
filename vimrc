"@milikecoding vim configurations.
"inspiration taken from skwp, sublime text,and rubymine

" use vim settings, not vi
set nocompatible

"  =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
  endif

" ================ General Config ====================
set hidden "make tabs act like other editors
set showcmd "incomplete commands at bottom
set showmode "current mode visible at bottom
set visualbell "no sounds
set number "line numbers
set history=1000 "command history length
set autoread "reload files changed outside of vim
set cursorline
set ruler
syntax on "turn on syntax highlighting
let mapleader="," "replace \ as leader because it's too far away

" ================ Interaction ====================
" Allow mouse scrolling
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
set mouse=a

" Bubble single lines
nmap <C-K> ddkP
nmap <C-J> ddp
" Bubble multiple lines
vmap <C-K> xkP`[V`]
vmap <C-J> xp`[V`]

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
    set undodir=~/.vim/backups
      set undofile
      endif

" ================ Indentation ======================
 set autoindent
 set smartindent
 set smarttab
 set shiftwidth=2
 set softtabstop=2
 set tabstop=2
 set expandtab
 filetype plugin on
 filetype indent on

" Display tabs and trailing spaces visually
" set list listchars=tab:\ \ ,trail:·

 set nowrap       "Don't wrap lines
 set linebreak    "Wrap lines at convenient points

 " ================ Folds ============================
 set foldmethod=indent   "fold based on indent
 set foldnestmax=3       "deepest fold is 3 levels
 set nofoldenable        "dont fold by default

 " ================ Completion =======================
 set wildmode=list:longest
 set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
 set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
 set wildignore+=*vim/backups*
 set wildignore+=*sass-cache*
 set wildignore+=*DS_Store*
 set wildignore+=vendor/rails/**
 set wildignore+=vendor/cache/**
 set wildignore+=*.gem
 set wildignore+=log/**
 set wildignore+=tmp/**
 set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================
 set scrolloff=8         "Start scrolling when we're 8 lines away from margins
 set sidescrolloff=15
 set sidescroll=1

 " ================ Search ===========================
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
nnoremap <silent> <C-l> :nohl<CR><C-l> " <Ctrl-l> redraws the screen and removes any search highlighting.
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital"

 " ================ Appearance ===========================
set background=light
colorscheme solarized
" solarized options
let g:solarized_termcolors = 16
let g:solarized_visibility = "normal"
let g:solarized_contrast = "normal"
let g:solarized_termtrans = 0
highlight clear SignColumn
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=4
autocmd StdinReadPre * let s:std_in=1

" ============ Plugin Configuration (to install new plugins, see vim/vundles.vim) ========

"indent guides
let g:indent_guides_auto_colors = 0
"Control P
let g:ctrlp_map = '<c-p>'
" Emmet
let g:user_emmet_leader_key='<C-Z>'
"syntax?
let g:syntastic_check_on_open=1
" Autosave
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
"git gutter
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0
" Airline
let g:airline#extensions#tabline#enabled = 1

 " ================ Manage buffers like tabs ===========================
nmap <leader>T :enew<cr> " To open a new empty buffer.This replaces :tabnew which I used to bind to this mapping
nmap <leader>l :bnext<CR> " Move to the next buffer
nmap <leader>h :bprevious<CR> " Move to the previous buffer
nmap <leader>bq :bp <BAR> bd #<CR> " Close the current buffer and move to the previous one. This replicates the idea of closing a tab
nmap <leader>bl :ls<CR> " Show all open buffers and their status

 " ================ Manage Netwr ===========================
let g:netrw_list_hide= '.*\.swp$'
let g:netrw_list_hide= '.DS_Store'
let g:netrw_banner = 0 " do not display info on the top of window
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4 " use the previous window to open file
"
