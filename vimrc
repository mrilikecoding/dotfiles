set nocompatible

"  =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
  endif

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
