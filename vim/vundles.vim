" Vim plugin configuration
" ========================================
"
" This file contains the list of plugin installed using vundle plugin manager.
" Once you've updated the list of plugin, you can run vundle update by issuing
" the command :BundleInstall from within vim or directly invoking it from  the
" command line with the following syntax:
" vim --noplugin -u vim/vundles.vim -N "+set hidden" "+syntax on"  +BundleClean! +BundleInstall +qall

filetype off
"  set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle
set rtp+=~/.vim/vundles/ "Submodules"

call vundle#begin()
" let Vundle manage Vundle (required)
"
Plugin 'gmarik/vundle'

runtime languages.vundle
runtime git.vundle
runtime appearance.vundle
runtime textobjects.vundle
runtime search.vundle
runtime project.vundle
runtime vim-improvements.vundle

call vundle#end()
filetype plugin indent on

