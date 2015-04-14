" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mileszs/ack.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'gmarik/Vundle.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-reload'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-haml'
Plugin 'tomtom/tcomment_vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'TagHighlight'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'mattn/emmet-vim'
Plugin 'chrisbra/Recover.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'itspriddle/vim-jquery'
Plugin 'jeroenbourgois/vim-actionscript'
Plugin 'elzr/vim-json'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/syntastic'
Plugin 'junegunn/tabularize'
Plugin 'bling/vim-airline'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'altercation/vim-colors-solarized'
Plugin 'henrik/vim-indexed-search'
Plugin 'SearchComplete'
Plugin 'tpope/vim-endwise'
Plugin 'AutoTag'
Plugin 'matchit.zip'
Plugin 'AnsiEsc.vim'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin '907th/vim-auto-save'
Plugin 'mhinz/vim-startify'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'othree/html5.vim'
Plugin 'kshenoy/vim-signature'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
autocmd StdinReadPre * let s:std_in=1
let g:ctrlp_map = '<c-p>'
let g:user_emmet_leader_key='<C-Z>'
let g:syntastic_check_on_open=1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" My preference with using buffers. See `:h hidden` for more details
set hidden
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
map <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>

syntax on
set background=light
colorscheme solarized
" solarized options
let g:solarized_termcolors = 16
let g:solarized_visibility = "normal"
let g:solarized_contrast = "normal"
let g:solarized_termtrans = 0
" let g:indent_guides_auto_colors = 0

set cursorline
set ruler
set number

let g:neocomplcache_enable_at_startup = 1
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:gitgutter_realtime = 1

highlight clear SignColumn
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=4
let g:netrw_list_hide= '.*\.swp$'
let g:netrw_list_hide= '.DS_Store'


let g:gitgutter_eager = 0

 set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
 " tell vim to keep a backup file
 set backup
 "
 " tell vim where to put its backup files
 set backupdir=/private/tmp
 "
"  tell vim where to put swap files
 set dir=/private/tmp

" do not display info on the top of window
let g:netrw_banner = 0

let g:netrw_liststyle = 3
" use the previous window to open file
let g:netrw_browse_split = 4

" Bubble single lines
 nmap <C-Up> ddkP
 nmap <C-Down> ddp
" Bubble multiple lines
 vmap <C-Up> xkP`[V`]
 vmap <C-Down> xp`[V`]
"
