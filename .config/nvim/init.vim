lua require('init')
lua require('config')

" General settings {{{
syntax on
let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " True gui colors in terminal
set termguicolors
set nocursorline
set cursorlineopt=number
set tabstop=4   " How many columns of whitespace a \t is worth
set shiftwidth=4
set nowrap
set hlsearch    " Highlight founded words
set expandtab   " Use spaces when tabbing
set splitbelow         " Always split below
set list listchars=tab:▸·,trail:·,extends:> " invisible symbols
set keymap=russian-jcukenwin
set number
set mouse=a
set iminsert=0
set imsearch=0
set cinoptions=(0,+1s,:0,=2s,>s,c1s,g2s,h2s,j1,l1,m1,p2s,t0,u0,w1
set noswapfile
set colorcolumn=101
set scrolloff=7
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"}}}

nnoremap <C-n> :NvimTreeToggle<CR>

" auto close { and add semicolon if needed
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()

" refresh file when it's changed
set autoread
if ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(1000,'CheckUpdate')
endfunction

"refresh vimrc after exiting it
autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw

" usable undo
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.cache/.nvim/undo  "directory where the undo files will be stored
endif

nnoremap // :noh<esc>
