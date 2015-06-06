"@milikecoding vim configurations.
"inspiration taken from skwp, sublime text,and rubymine

" use vim settings, not vi
" nvim doesn't need this setting, but uncomment for regular vim
" set nocompatible

"  =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
  endif

if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
  endif

" ================ General Config ====================
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
nnoremap <silent> // :nohl<CR><C-l> " // redraws the screen and removes any search highlighting.
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital"

 " ================ Appearance ===========================
set background=dark
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

 " ================ Manage buffers like tabs ===========================
 " key mappings
nmap <leader>T :enew<cr> " To open a new empty buffer.This replaces :tabnew which I used to bind to this mapping
nmap <leader>; :bnext<CR> " Move to the next buffer
nmap <leader>l :bprevious<CR> " Move to the previous buffer
nmap <leader>bq :bp <BAR> bd #<CR> " Close the current buffer and move to the previous one. This replicates the idea of closing a tab
nmap <leader>bl :ls<CR> " Show all open buffers and their status

set hidden "make tabs act like other editors

" airline configuration - turn on tabline top, show just file name
" map numbers to buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" ================ Manage NERDTree ===========================
 autocmd VimEnter * NERDTree
 autocmd VimEnter * wincmd p
map <silent> <C-n> :NERDTreeToggle<CR>
" Select NERDTree file opens in Startify buffer  
autocmd User Startified set buftype=
