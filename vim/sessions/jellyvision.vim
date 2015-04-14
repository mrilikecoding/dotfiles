let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <expr> <Plug>(neocomplcache_start_unite_complete) unite#sources#neocomplcache#start_complete()
inoremap <silent> <expr> <Plug>(neocomplcache_start_unite_quick_match) unite#sources#neocomplcache#start_quick_match()
inoremap <silent> <Plug>(neocomplcache_start_auto_complete) =neocomplcache#mappings#popup_post()
inoremap <silent> <Plug>(neocomplcache_start_auto_complete_no_select) 
inoremap <silent> <Plug>(neocomplcache_start_omni_complete) 
inoremap <silent> <expr> <Plug>delimitMateS-BS delimitMate#WithinEmptyPair() ? "\<Del>" : "\<S-BS>"
inoremap <silent> <Plug>delimitMateBS =delimitMate#BS()
inoremap <silent> <C-F8> :RandomColorScheme
inoremap <silent> <S-F8> :PrevColorScheme
inoremap <silent> <F8> :NextColorScheme
inoremap <Plug>(emmet-anchorize-summary) =emmet#util#closePopup()=emmet#anchorizeURL(1)
inoremap <Plug>(emmet-anchorize-url) =emmet#util#closePopup()=emmet#anchorizeURL(0)
inoremap <Plug>(emmet-remove-tag) =emmet#util#closePopup()=emmet#removeTag()
inoremap <Plug>(emmet-split-join-tag) :call emmet#splitJoinTag()
inoremap <Plug>(emmet-toogle-comment) =emmet#util#closePopup()=emmet#toggleComment()
inoremap <Plug>(emmet-image-size) =emmet#util#closePopup()=emmet#imageSize()
inoremap <Plug>(emmet-move-prev) :call emmet#moveNextPrev(1)
inoremap <Plug>(emmet-move-next) :call emmet#moveNextPrev(0)
inoremap <Plug>(emmet-balance-tag-outword) :call emmet#balanceTag(-1)
inoremap <Plug>(emmet-balance-tag-inward) :call emmet#balanceTag(1)
inoremap <Plug>(emmet-update-tag) =emmet#util#closePopup()=emmet#updateTag()
inoremap <Plug>(emmet-expand-word) =emmet#util#closePopup()=emmet#expandAbbr(1,"")
inoremap <Plug>(emmet-expand-abbr) =emmet#util#closePopup()=emmet#expandAbbr(0,"")
inoremap <Plug>TComment-9 :call tcomment#SetOption("count", 9)
inoremap <Plug>TComment-8 :call tcomment#SetOption("count", 8)
inoremap <Plug>TComment-7 :call tcomment#SetOption("count", 7)
inoremap <Plug>TComment-6 :call tcomment#SetOption("count", 6)
inoremap <Plug>TComment-5 :call tcomment#SetOption("count", 5)
inoremap <Plug>TComment-4 :call tcomment#SetOption("count", 4)
inoremap <Plug>TComment-3 :call tcomment#SetOption("count", 3)
inoremap <Plug>TComment-2 :call tcomment#SetOption("count", 2)
inoremap <Plug>TComment-1 :call tcomment#SetOption("count", 1)
inoremap <Plug>TComment-s :TCommentAs =&ft_
inoremap <Plug>TComment-n :TCommentAs =&ft 
inoremap <Plug>TComment-a :TCommentAs 
inoremap <Plug>TComment-b :TCommentBlock mode=#
inoremap <Plug>TComment-i v:TCommentInline mode=#
inoremap <Plug>TComment-r :TCommentRight
inoremap <Plug>TComment-  :TComment 
inoremap <Plug>TComment-p :norm! m`vip:TComment``
inoremap <Plug>TComment- :TComment
nnoremap <silent>  :CtrlP
nnoremap <silent>  :call repeat#wrap("\<C-R>",v:count)
vmap c <Plug>(emmet-code-pretty)
vmap m <Plug>(emmet-merge-lines)
nmap A <Plug>(emmet-anchorize-summary)
nmap a <Plug>(emmet-anchorize-url)
nmap k <Plug>(emmet-remove-tag)
nmap j <Plug>(emmet-split-join-tag)
nmap / <Plug>(emmet-toogle-comment)
nmap i <Plug>(emmet-image-size)
nmap N <Plug>(emmet-move-prev)
nmap n <Plug>(emmet-move-next)
vmap D <Plug>(emmet-balance-tag-outword)
nmap D <Plug>(emmet-balance-tag-outword)
vmap d <Plug>(emmet-balance-tag-inward)
nmap d <Plug>(emmet-balance-tag-inward)
nmap u <Plug>(emmet-update-tag)
nmap ; <Plug>(emmet-expand-word)
vmap , <Plug>(emmet-expand-abbr)
nmap , <Plug>(emmet-expand-abbr)
nmap 9 <Plug>TComment-9
nmap 8 <Plug>TComment-8
nmap 7 <Plug>TComment-7
nmap 6 <Plug>TComment-6
nmap 5 <Plug>TComment-5
nmap 4 <Plug>TComment-4
nmap 3 <Plug>TComment-3
nmap 2 <Plug>TComment-2
nmap 1 <Plug>TComment-1
nmap  <Plug>TComment-
vmap 9 <Plug>TComment-9
omap 9 <Plug>TComment-9
vmap 8 <Plug>TComment-8
omap 8 <Plug>TComment-8
vmap 7 <Plug>TComment-7
omap 7 <Plug>TComment-7
vmap 6 <Plug>TComment-6
omap 6 <Plug>TComment-6
vmap 5 <Plug>TComment-5
omap 5 <Plug>TComment-5
vmap 4 <Plug>TComment-4
omap 4 <Plug>TComment-4
vmap 3 <Plug>TComment-3
omap 3 <Plug>TComment-3
vmap 2 <Plug>TComment-2
omap 2 <Plug>TComment-2
vmap 1 <Plug>TComment-1
omap 1 <Plug>TComment-1
map ca <Plug>TComment-ca
map cc <Plug>TComment-cc
map s <Plug>TComment-s
map n <Plug>TComment-n
map a <Plug>TComment-a
map b <Plug>TComment-b
map i <Plug>TComment-i
map r <Plug>TComment-r
map   <Plug>TComment- 
map p <Plug>TComment-p
vmap  <Plug>TComment-
omap  <Plug>TComment-
nnoremap <silent> # #:ShowSearchIndex
nnoremap <silent> * *:ShowSearchIndex
nnoremap <silent> . :call repeat#run(v:count)
noremap / :call SearchCompleteStart()/
nnoremap ? :ShowSearchIndex?
nnoremap <silent> N Nzv:ShowSearchIndex
xmap S <Plug>VSurround
nnoremap <silent> U :call repeat#wrap('U',v:count)
vmap [% [%m'gv``
nmap \__ <Plug>TComment-\__
smap \__ <Plug>TComment-\__
map \rwp <Plug>RestoreWinPosn
map \swp <Plug>SaveWinPosn
map \_s <Plug>TComment-\_s
map \_n <Plug>TComment-\_n
map \_a <Plug>TComment-\_a
map \_b <Plug>TComment-\_b
map \_r <Plug>TComment-\_r
xmap \_i <Plug>TComment-\_i
map \_  <Plug>TComment-\_ 
map \_p <Plug>TComment-\_p
xmap \__ <Plug>TComment-\__
omap \__ <Plug>TComment-\__
nmap \bl :ls
nmap \bq :bp | bd #
nmap \h :bprevious
nmap \l :bnext
map \T :enew
vmap ]% ]%m'gv``
vmap a% [%v]%
nmap cs <Plug>Csurround
nmap ds <Plug>Dsurround
nmap gx <Plug>NetrwBrowseX
xmap gS <Plug>VgSurround
xmap g> <Plug>TComment-Comment
nmap <silent> g>b <Plug>TComment-Commentb
nmap <silent> g>c <Plug>TComment-Commentc
nmap <silent> g> <Plug>TComment-Comment
xmap g< <Plug>TComment-Uncomment
nmap <silent> g<b <Plug>TComment-Uncommentb
nmap <silent> g<c <Plug>TComment-Uncommentc
nmap <silent> g< <Plug>TComment-Uncomment
xmap gc <Plug>TComment-gc
nmap <silent> gcb <Plug>TComment-gcb
nmap <silent> gcc <Plug>TComment-gcc
nmap <silent> gc9 <Plug>TComment-gc9
nmap <silent> gc8 <Plug>TComment-gc8
nmap <silent> gc7 <Plug>TComment-gc7
nmap <silent> gc6 <Plug>TComment-gc6
nmap <silent> gc5 <Plug>TComment-gc5
nmap <silent> gc4 <Plug>TComment-gc4
nmap <silent> gc3 <Plug>TComment-gc3
nmap <silent> gc2 <Plug>TComment-gc2
nmap <silent> gc1 <Plug>TComment-gc1
nmap <silent> gc <Plug>TComment-gc
omap ic <Plug>TComment-ic
vmap ic <Plug>TComment-ic
nnoremap <silent> n nzv:ShowSearchIndex
nnoremap <silent> u :call repeat#wrap('u',v:count)
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap yss <Plug>Yssurround
nmap yS <Plug>YSurround
nmap ys <Plug>Ysurround
nnoremap <Plug>TComment-9 :call tcomment#SetOption("count", 9)
nnoremap <Plug>TComment-8 :call tcomment#SetOption("count", 8)
nnoremap <Plug>TComment-7 :call tcomment#SetOption("count", 7)
nnoremap <Plug>TComment-6 :call tcomment#SetOption("count", 6)
nnoremap <Plug>TComment-5 :call tcomment#SetOption("count", 5)
nnoremap <Plug>TComment-4 :call tcomment#SetOption("count", 4)
nnoremap <Plug>TComment-3 :call tcomment#SetOption("count", 3)
nnoremap <Plug>TComment-2 :call tcomment#SetOption("count", 2)
nnoremap <Plug>TComment-1 :call tcomment#SetOption("count", 1)
nnoremap <Plug>TComment-\__ :TComment
snoremap <Plug>TComment-\__ :TComment
nnoremap <Plug>TComment- :TComment
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
nnoremap <silent> <Plug>SurroundRepeat .
nmap <silent> <Plug>RestoreWinPosn :call RestoreWinPosn()
nmap <silent> <Plug>SaveWinPosn :call SaveWinPosn()
nnoremap <silent> <C-F8> :RandomColorScheme
nnoremap <silent> <S-F8> :PrevColorScheme
nnoremap <silent> <F8> :NextColorScheme
vnoremap <Plug>(emmet-code-pretty) :call emmet#codePretty()
vnoremap <Plug>(emmet-merge-lines) :call emmet#mergeLines()
nnoremap <Plug>(emmet-anchorize-summary) :call emmet#anchorizeURL(1)
nnoremap <Plug>(emmet-anchorize-url) :call emmet#anchorizeURL(0)
nnoremap <Plug>(emmet-remove-tag) :call emmet#removeTag()
nnoremap <Plug>(emmet-split-join-tag) :call emmet#splitJoinTag()
nnoremap <Plug>(emmet-toogle-comment) :call emmet#toggleComment()
nnoremap <Plug>(emmet-image-size) :call emmet#imageSize()
nnoremap <Plug>(emmet-move-prev) :call emmet#moveNextPrev(1)
nnoremap <Plug>(emmet-move-next) :call emmet#moveNextPrev(0)
vnoremap <Plug>(emmet-balance-tag-outword) :call emmet#balanceTag(-2)
nnoremap <Plug>(emmet-balance-tag-outword) :call emmet#balanceTag(-1)
vnoremap <Plug>(emmet-balance-tag-inward) :call emmet#balanceTag(2)
nnoremap <Plug>(emmet-balance-tag-inward) :call emmet#balanceTag(1)
nnoremap <Plug>(emmet-update-tag) :call emmet#updateTag()
nnoremap <Plug>(emmet-expand-word) :call emmet#expandAbbr(1,"")
vnoremap <Plug>(emmet-expand-abbr) :call emmet#expandAbbr(2,"")
nnoremap <Plug>(emmet-expand-abbr) :call emmet#expandAbbr(3,"")
nnoremap <silent> <Plug>TComment-gc9c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 9) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc8c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 8) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc7c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 7) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc6c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 6) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc5c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 5) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc4c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 4) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc3c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 3) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc2c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 2) | set opfunc=tcomment#Operatorg@
nnoremap <silent> <Plug>TComment-gc1c :let w:tcommentPos = getpos(".") | call tcomment#SetOption("count", 1) | set opfunc=tcomment#Operatorg@
vnoremap <Plug>TComment-9 :call tcomment#SetOption("count", 9)
onoremap <Plug>TComment-9 :call tcomment#SetOption("count", 9)
vnoremap <Plug>TComment-8 :call tcomment#SetOption("count", 8)
onoremap <Plug>TComment-8 :call tcomment#SetOption("count", 8)
vnoremap <Plug>TComment-7 :call tcomment#SetOption("count", 7)
onoremap <Plug>TComment-7 :call tcomment#SetOption("count", 7)
vnoremap <Plug>TComment-6 :call tcomment#SetOption("count", 6)
onoremap <Plug>TComment-6 :call tcomment#SetOption("count", 6)
vnoremap <Plug>TComment-5 :call tcomment#SetOption("count", 5)
onoremap <Plug>TComment-5 :call tcomment#SetOption("count", 5)
vnoremap <Plug>TComment-4 :call tcomment#SetOption("count", 4)
onoremap <Plug>TComment-4 :call tcomment#SetOption("count", 4)
vnoremap <Plug>TComment-3 :call tcomment#SetOption("count", 3)
onoremap <Plug>TComment-3 :call tcomment#SetOption("count", 3)
vnoremap <Plug>TComment-2 :call tcomment#SetOption("count", 2)
onoremap <Plug>TComment-2 :call tcomment#SetOption("count", 2)
vnoremap <Plug>TComment-1 :call tcomment#SetOption("count", 1)
onoremap <Plug>TComment-1 :call tcomment#SetOption("count", 1)
nnoremap <silent> <Plug>TComment-gc :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | let w:tcommentPos = getpos(".") | set opfunc=tcomment#Operatorg@
xnoremap <Plug>TComment-gc :TCommentMaybeInline
nnoremap <silent> <Plug>TComment-gcb :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | let w:tcommentPos = getpos(".") | call tcomment#SetOption("mode_extra", "B") | set opfunc=tcomment#OperatorLineg@
nnoremap <silent> <Plug>TComment-gcc :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorLineg@$
noremap <Plug>TComment-ic :call tcomment#TextObjectInlineComment()
xnoremap <silent> <Plug>TComment-Comment :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | '<,'>TCommentMaybeInline!
nnoremap <silent> <Plug>TComment-Commentb :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | call tcomment#SetOption("mode_extra", "B") | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorLineg@
nnoremap <silent> <Plug>TComment-Commentc :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorLineAnywayg@$
nnoremap <silent> <Plug>TComment-Comment :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorAnywayg@
xnoremap <silent> <Plug>TComment-Uncomment :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | call tcomment#SetOption("mode_extra", "U") | '<,'>TCommentMaybeInline
nnoremap <silent> <Plug>TComment-Uncommentb :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | call tcomment#SetOption("mode_extra", "UB") | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorLineg@
nnoremap <silent> <Plug>TComment-Uncommentc :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | call tcomment#SetOption("mode_extra", "U") | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorLineAnywayg@$
nnoremap <silent> <Plug>TComment-Uncomment :if v:count > 0 | call tcomment#SetOption("count", v:count) | endif | call tcomment#SetOption("mode_extra", "U") | let w:tcommentPos = getpos(".") | set opfunc=tcomment#OperatorAnywayg@
noremap <Plug>TComment-\_s :TCommentAs =&ft_
noremap <Plug>TComment-\_n :TCommentAs =&ft 
noremap <Plug>TComment-\_a :TCommentAs 
noremap <Plug>TComment-\_b :TCommentBlock
noremap <Plug>TComment-\_r :TCommentRight
xnoremap <Plug>TComment-\_i :TCommentInline
noremap <Plug>TComment-\_  :TComment 
noremap <Plug>TComment-\_p vip:TComment
xnoremap <Plug>TComment-\__ :TCommentMaybeInline
onoremap <Plug>TComment-\__ :TComment
noremap <Plug>TComment-ca :call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#Complete"))
noremap <Plug>TComment-cc :call tcomment#SetOption("count", v:count1)
noremap <Plug>TComment-s :TCommentAs =&ft_
noremap <Plug>TComment-n :TCommentAs =&ft 
noremap <Plug>TComment-a :TCommentAs 
noremap <Plug>TComment-b :TCommentBlock
noremap <Plug>TComment-i v:TCommentInline mode=I#
noremap <Plug>TComment-r :TCommentRight
noremap <Plug>TComment-  :TComment 
noremap <Plug>TComment-p m`vip:TComment``
vnoremap <Plug>TComment- :TCommentMaybeInline
onoremap <Plug>TComment- :TComment
imap S <Plug>ISurround
imap s <Plug>Isurround
imap  <Plug>DiscretionaryEnd
imap  <Plug>Isurround
imap A <Plug>(emmet-anchorize-summary)
imap a <Plug>(emmet-anchorize-url)
imap k <Plug>(emmet-remove-tag)
imap j <Plug>(emmet-split-join-tag)
imap / <Plug>(emmet-toogle-comment)
imap i <Plug>(emmet-image-size)
imap N <Plug>(emmet-move-prev)
imap n <Plug>(emmet-move-next)
imap D <Plug>(emmet-balance-tag-outword)
imap d <Plug>(emmet-balance-tag-inward)
imap u <Plug>(emmet-update-tag)
imap ; <Plug>(emmet-expand-word)
imap , <Plug>(emmet-expand-abbr)
imap 9 <Plug>TComment-9
imap 8 <Plug>TComment-8
imap 7 <Plug>TComment-7
imap 6 <Plug>TComment-6
imap 5 <Plug>TComment-5
imap 4 <Plug>TComment-4
imap 3 <Plug>TComment-3
imap 2 <Plug>TComment-2
imap 1 <Plug>TComment-1
imap s <Plug>TComment-s
imap n <Plug>TComment-n
imap a <Plug>TComment-a
imap b <Plug>TComment-b
imap i <Plug>TComment-i
imap r <Plug>TComment-r
imap   <Plug>TComment- 
imap p <Plug>TComment-p
imap  <Plug>TComment-
let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set backspace=2
set completefunc=neocomplcache#complete#manual_complete
set completeopt=preview,menuone
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set hidden
set modelines=0
set ruler
set runtimepath=~/.vim,~/.vim/bundle/Vundle.vim,~/.vim/bundle/molokai,~/.vim/bundle/vim-javascript,~/.vim/bundle/vim-misc,~/.vim/bundle/vim-reload,~/.vim/bundle/vim-fugitive,~/.vim/bundle/ctrlp.vim,~/.vim/bundle/vim-rails,~/.vim/bundle/tcomment_vim,~/.vim/bundle/TagHighlight,~/.vim/bundle/neocomplcache.vim,~/.vim/bundle/emmet-vim,~/.vim/bundle/vim-javascript-syntax,~/.vim/bundle/vim-jquery,~/.vim/bundle/vim-actionscript,~/.vim/bundle/vim-colorscheme-switcher,~/.vim/bundle/vim-json,~/.vim/bundle/delimitMate,~/.vim/bundle/syntastic,~/.vim/bundle/tabularize,~/.vim/bundle/vim-airline,~/.vim/bundle/vim-mustache-handlebars,~/.vim/bundle/vim-colors-solarized,~/.vim/bundle/vim-indexed-search,~/.vim/bundle/SearchComplete,~/.vim/bundle/vim-endwise,~/.vim/bundle/AutoTag,~/.vim/bundle/matchit.zip,~/.vim/bundle/AnsiEsc.vim,~/.vim/bundle/vim-repeat,~/.vim/bundle/vim-indent-guides,~/.vim/bundle/vim-sessions,~/.vim/bundle/vim-surround,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,~/.vim/after,~/.vim/bundle/Vund
set showtabline=2
set tabline=%!airline#extensions#tabline#get()
set updatetime=200
set window=0
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Development/jellyvision/sp/surepayroll/app/scripts
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +22 application.js
badd +70 animationRegion.js
args application.js
edit application.js
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <S-Tab> <Plug>delimitMateS-Tab
imap <buffer> <S-BS> <Plug>delimitMateS-BS
imap <buffer> <BS> <Plug>delimitMateBS
imap <buffer> <silent> g <Plug>delimitMateJumpMany
imap <buffer>  <Plug>delimitMateBS
imap <buffer> " <Plug>delimitMate"
imap <buffer> ' <Plug>delimitMate'
imap <buffer> ( <Plug>delimitMate(
imap <buffer> ) <Plug>delimitMate)
imap <buffer> [ <Plug>delimitMate[
imap <buffer> ] <Plug>delimitMate]
imap <buffer> ` <Plug>delimitMate`
imap <buffer> { <Plug>delimitMate{
imap <buffer> } <Plug>delimitMate}
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal noautoindent
setlocal nobinary
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal complete=.,w,b,u,t,i
setlocal completefunc=neocomplcache#complete#auto_complete
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
set cursorline
setlocal cursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'javascript'
setlocal filetype=javascript
endif
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=0
setlocal include=
setlocal includeexpr=
setlocal indentexpr=GetJavascriptIndent()
setlocal indentkeys=0{,0},0),0],0,,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255,$
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal nolist
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=javascriptcomplete#CompleteJS
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal noscrollbind
setlocal shiftwidth=8
setlocal noshortname
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%!airline#statusline(1)
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'javascript'
setlocal syntax=javascript
endif
setlocal tabstop=8
setlocal tags=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 22 - ((21 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 0
lcd ~/Development/jellyvision/sp/surepayroll/app/scripts
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
