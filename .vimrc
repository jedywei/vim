"
" Install Vundle
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
"
" :so %   		    <-- reload .vimrc
" :set no<option>	<--- unset option
" :help <options>
" :set <option>?	<-- show the option value
" :map <F2>         <-- to get <F2> binding (or map)
"
"--------------------------------------------------------------
" Features {{{ 1
"
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as snely reset optiions when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filtype,
" and for plugins that are filetype specific.

" Enable syntax highlighting
syntax on
set background=dark
colorscheme valloric

"---------------------------------------------------------------------
" Vundle plugin {{{ 1
" Brief help / :PluginList / :PluginInstall / :PluginSearch <foo>

filetype off    
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"-------------------------------------------------------------------
" Plugin {{{ 1
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlp.vim'
"Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'kshenoy/vim-signature'
Plugin 'mileszs/ack.vim'
Plugin 'vim-scripts/a.vim'
" restore_view.vim will change my current directory to for example ../great/reef
" it's really annoyed 
"Plugin 'vim-scripts/restore_view.vim'
" vader.vim is alt-key mapping in terminal 
"Plugin 'junegunn/vader.vim'

" vundle#end() can active all Plugin
call vundle#end()
filetype plugin indent on

"-------------------------------------------------------------------
" Setting for Plugin {{{ 1
"
" vim-airline setting

set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_theme='bubblegum'
"let g:airline_theme='dark'
" enable tabline
let g:airline#extensions#tabline#enabled=1
" set left separator
let g:airline#extension#tabline#left_sep=' '
" set left separator which are not editting
let g:airline#extension#tabline#left_alt_sep ='|'
" show buffer number
let g:airline#extension#tabline#buffer_nr_show=1
set encoding=utf-8
set ttimeoutlen=50


"
" Tagbar
nmap <leader>L :TagbarToggle<cr>
cnoremap <silent>L<cr> :TagbarToggle<cr>
let g:tagbar_autofocus=1
let g:tagbar_width=30

"
" CtrlP
let g:ctrlp_map='<C-p>'
let g:cgrlp_cmd='CtrlP'
map <leader>f :CtrlPMRU<cr>
let g:ctrlp_custom_ignore={
    \ 'dir': '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tgz|tar.gz|pyc|mov|png|h265|h264)$',
    \}
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
let g:ctrlp_open_new_file='e'
let g:ctrlp_by_filename=1

"---------------------------------------------------------------------------------------
" YouCompleteMe
"
"ucomment following command will disable YCM module
"let g:loaded_youcompleteme=1
" :h ins-completion-menu
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
let g:ycm_complete_in_strings=1
let g:ycm_complete_in_comments=1
let g:ycm_sed_identifiers_with_syntax=1
let g:ycm_min_num_of_chars_for_completion=1
let g:ycm_confirm_extra_conf=0
let g:ycm_complete_in_strings=1
let g:ycm_error_symbol='>>'
let g:ycm_warning_symbol='>*'
"let g:ycm_enable_diagnostic_signs=0
"let g:ycm_enable_diagnostic_highlighting=0
"let g:ycm_key_list_previous_completion = ['<S-TAB>']
"let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_stop_completion = ['<C-y>']
let g:ycm_key_list_previous_completion=['<C-p>', '<S-TAB>']
let g:ycm_key_list_select_completion=['<C-n>', '<TAB>']
"inoremap <expr><CR> pumvisible() ? "\<C-E>" : "\<CR>"
inoremap <expr><Up> pumvisible() ? "\<Up>" : "\<Esc>gk"
inoremap <expr><Down> pumvisible() ? "\<Down>" : "\<Esc>gj"
inoremap <expr><Left> pumvisible() ? "\<C-e>\<Esc>a" : "\<Esc>\<Left>"
inoremap <expr><Right> pumvisible() ? "\<C-y>" : "\<Esc>\<Right>"
set completeopt=longest,menu
nnoremap gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap gf :YcmCompleter GoToDefinition<CR>
nnoremap gl :YcmCompleter GoToDeclaration<CR>
nnoremap gi :YcmCompleter GoToInclude<CR>
nnoremap gb <C-O>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:SuperTabDefaultCompletionType='<C-n>'
let g:UltiSnipsExpandTrigger='<C-j>'
"let g:UltiSnipsJumpForwardTrigger="<Tab>"
"let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
"let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips']


" vim-signature remove SignColumn highlight color  
highlight SignColumn ctermbg=none
highlight SignatureMartText ctermbg=none

"-------------------------------------------------------------
" Must have options {{{ 1
"
" 'hidden' option, which allows you to re-use the same window and switch
" from an unsaved buffer without saving it first. 
set hidden
"set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlight
set hlsearch
" Modelines have historically been a source of security vunerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script
"
" set nomodeline

"-------------------------------------------------------------
" Usability options {{{ 1
"
" Allow backspacing over autoindent, line breaks and start of insert action
"set ignorecase
"set smartcase
set backspace=indent,eol,start
set number
set autoindent
set nostartofline
set ruler
"set laststatus=2
set confirm
set visualbell
" And reset the terminal code for the visual bell. If visuallbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
set mouse=
" set mouse=a
set pastetoggle=<F10>

"----------------------------------------------------------------------
" Identation options {{{ 1
set shiftwidth=4
set softtabstop=4
set expandtab
set laststatus=2

"----------------------------------------------------------------------
" Folding options {{{ 1         
" zo zc za (toggle) zR/zM
set foldenable
set foldmethod=syntax
set foldnestmax=6
set foldlevelstart=6
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
"nmap <Space> zA

syn match cCustomFunc /\w\+\s*(/me=e-1,he=e-1
hi def link cCustomFunc Function

"----------------------------------------------------------------------
" Resotre-view option {{{ 1

set viewoptions=cursor,folds,slash,unix
"let g:skipview_files=['\.vim']

"----------------------------------------------------------------------
" Mappings {{{ 1

" Map <C-L> (redraw screen) to also turn off search highlighting utnil the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Buffer <- ->
nnoremap <C-A-Right> :bnext<CR>
nnoremap <C-A-Left> :bprev<CR>
inoremap <C-A-Right> <ESC>:bnext<CR>
inoremap <C-A-Left> <Esc>:bprev<CR>


" Quickfix up / down 
nnoremap <C-A-Down> :cnext<CR>
nnoremap <C-A-Up> :cprev<CR>
inoremap <C-A-Down> <Esc>:cnext<CR>
inoremap <C-A-Up> <Esc>:cprev<CR>

" Cursor Movement
"inoremap <Left> <Esc><Left>
"inoremap <Right> <Esc><Right>
"inoremap <Down> <Esc>gj
"inoremap <Up> <Esc>gk
inoremap <S-Left> <Left>
inoremap <S-Right> <Right>
inoremap <S-Up> <Up>
inoremap <S-Down> <Down>
noremap <S-Left> <Left>
noremap <S-Right> <Right>
noremap <S-Up> <Up>
noremap <S-Down> <Down>
nnoremap <Down> gj
nnoremap <Up> gk

"
inoremap <A-Left> <Esc>B
inoremap <A-Right> <Esc>W
nnoremap <A-Left> B
nnoremap <A-Right> W

" move between last editor
inoremap <C-Up> <Esc>g;
inoremap <C-Down> <Esc>g,
nnoremap <C-Up> g;
nnoremap <C-Down> g,

inoremap <silent><C-Right> <Esc>:YcmCompleter GoToDefinitionElseDeclaration<CR>
inoremap <C-Left> <Esc><C-o>
nnoremap <silent><C-Right> :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <C-Left> <C-o>
" 
inoremap <A-Up> <Esc>[[
inoremap <A-Down> <Esc>]]
nnoremap <A-Up> [[
nnoremap <A-Down> ]]
"save
nnoremap <silent><C-s> :wa<CR>
inoremap <silent><C-s> <C-o>:wa<CR>
noremap <silent><C-a> :wa<CR>:make<CR>
inoremap <silent><C-a> <Esc>:wa<CR>:make<CR>

" quit
nnoremap <silent>zz :quit<CR>

"delete
"inoremap    <M-.>   <Del>
"nnoremap    <M-.>   <Del>

"nnoremap    <M-/>   dw
"inoremap    <M-/>   <Esc>dwi

"insert a new line on normal mode
"nmap <CR> o<Esc>

let $VIMPROMPT="(vi)"


"set autochdir
"autocmd VimEnter * set autochdir
