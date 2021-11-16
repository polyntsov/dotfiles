set nocompatible
filetype off    " required

set noshowmode

" Vundle Plugins {{{

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" auto-pairs
Plugin 'jiangmiao/auto-pairs'

" C/C++ syntax highlighting
"Plugin 'octol/vim-cpp-enhanced-highlight'
"Plugin 'bfrg/vim-cpp-modern'
Plugin 'jackguo380/vim-lsp-cxx-highlight'

" colorscheme
Plugin 'dylnmc/vim-colors-rakr'
Plugin 'joshdick/onedark.vim'
Plugin 'cliuj/vim-dark-meadow'
Plugin 'sjl/badwolf'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'sonph/onehalf', { 'rtp': 'vim' }
Plugin 'dracula/vim'
Plugin 'challenger-deep-theme/vim', {'name': 'challenger-deep-theme'}
Plugin 'altercation/vim-colors-solarized'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'rbgrouleff/bclose.vim'
Plugin 'mhartington/oceanic-next'
"Plugin 'chriskempson/base16-vim'
Plugin 'tomasiser/vim-code-dark'
Plugin 'sickill/vim-monokai'
Plugin 'vim-scripts/grep.vim'
Plugin 'dbakker/vim-projectroot'
"Plugin 'colorsupport.vim' " colorschemes look like in gvim
" Plugin 'Valloric/vim-operator-highlight' " operator symbols highlighting

" tmux statusline
"Plugin 'edkolev/tmuxline.vim'

" File system explorer
Plugin 'preservim/nerdtree'

" Status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Auto-completion
"Plugin 'ycm-core/YouCompleteMe'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" Git integration
Plugin 'tpope/vim-fugitive'

" Syntax highlighting for gvim
" Plugin 'davits/DyeVim'

" File search
Plugin 'ctrlpvim/ctrlp.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"}}}

" Plugins options {{{
" Coc highlighting
let g:coc_default_semantic_highlight_groups = 0

" YCM
"let g:ycm_echo_current_diagnostic = 0
"let g:ycm_show_diagnostics_ui = 0
"let g:clang_snippets_engine='clang_complete'

" Airline theme
let g:airline_theme='codedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1

" File search, CtrlP
" Change the default mapping and the default command to invoke CtrlP:
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" When invoked without an explicit starting directory,
" CtrlP will set its local working directory according to this variable:
let g:ctrlp_working_path_mode = 'ra'

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" tmux line
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : '#W',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '#W %R',
      \'z'    : '#H'}

" grep
"grep options
let Grep_Default_Filelist = '*.[ch] *.cc *.cpp *.hpp'
"let g:Grep_Default_Filelist .= " --exclude=\'*.git\'"
"let g:Grep_Default_Filelist .= " --exclude=.tags"
"let Grep_Skip_Dirs = 'openwrt'
"let Grep_Skip_Files = 'ledctrl_parsed.c ledcetrl.h ledctrl.c'
execute 'nnoremap <F3> :Rgrep<CR><CR><C-u>' . projectroot#guess() . '<CR><CR>'
execute 'vnoremap <F3> y:Rgrep<CR><C-u><C-r>"<CR><C-u>' . projectroot#guess() . '<CR><CR>'

"}}}

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
  set undodir=$HOME/.nvim/undo  "directory where the undo files will be stored
endif

" General settings {{{
syntax on
set termguicolors
if !has('nvim')
    set cursorline
    set cursorlineopt=number
endif
set tabstop=4   " How many columns of whitespace a \t is worth
set shiftwidth=4
set nowrap
set hlsearch    " Highlight founded words
set expandtab   " Use spaces when tabbing
"set termwinsize=12x0   " Set terminal size
set splitbelow         " Always split below
set list listchars=tab:▸·,trail:·,extends:> " invisible symbols
set keymap=russian-jcukenwin
set number
set mouse=a
set iminsert=0
set imsearch=0
set cinoptions=(0,+1s,:0,=2s,>s,c1s,g2s,h2s,j1,l1,m1,p2s,t0,u0,w1

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }}}

" COC settings {{{

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
let g:coc_default_semantic_highlight_groups = 1
"}}}

" NERDTree mappings {{{

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"}}}

" General Mappings
nnoremap // :noh<esc>
nnoremap gs :CocCommand clangd.switchSourceHeader<esc>

" colorscheme
set background=dark
"let g:tokyonight_style = 'night' " available: night, storm

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme codedark

" Highlighting options; should be here to override colorscheme highlighting
hi MatchParen ctermfg=magenta cterm=bold gui=bold guibg=NONE guifg=magenta
hi CursorLineNR term=bold cterm=bold guifg=cyan
hi ExtraWhitespace term=NONE cterm=NONE gui=NONE guifg=red ctermfg=red
hi link LspCxxHlGroupNamespace Type
match ExtraWhitespace /\s\+$/
match Type /\<auto\>/
" vim: set fdl=0 fdm=marker:
