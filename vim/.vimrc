filetype plugin indent on

syntax on
" cuda syntax highlighting for .cuh files
au BufNewFile,BufRead *.cuh setf cuda

try
    "colorscheme angr
    "colorscheme dark_plus
    "colorscheme base16-ashes
    "colorscheme base16-atelier-cave
    "colorscheme base16-atelier-estuary
    "colorscheme base16-atelier-heath
    "colorscheme base16-atelier-savanna
    "colorscheme base16-chalk
    "colorscheme base16-dracula
    "colorscheme base16-embers
    "colorscheme base16-ia-dark
    "colorscheme base16-material-vivid
    "colorscheme base16-synth-midnight-dark
    "colorscheme base16-twilight
    colorscheme base16-woodland
    "colorscheme base16-zenburn
catch
    colorscheme desert
endtry
function FixBackground()
    set termguicolors
    hi Normal  ctermbg=none guibg=none
    hi NonText ctermbg=none guibg=none
    set t_Co=256
endfunction
call FixBackground()
" Fix background on colorscheme change
augroup on_change_colorschema
    autocmd!
    "autocmd ColorScheme * call s:base16_customize()
    autocmd ColorScheme * call FixBackground()
augroup END

if has('nvim')
    " Neovim specific commands
    "tnoremap <Esc><Esc> <C-\><C-n>
    tnoremap <C-n> <C-\><C-n>
    nnoremap <C-t> :sp<cr>:wincmd j<cr>:term<cr><C-w>20-<cr>
    au TermOpen * setlocal nonumber norelativenumber
else
    " Standard vim specific commands
endif

" change tabs to spaces
set expandtab
" show existing tab with 4 spaces width
set tabstop=4
" allow backspace to erase up to 4 spaces
set softtabstop=4
" indent with 4 spaces
set shiftwidth=4
function ThreeSpaces()
    set tabstop=3
    set softtabstop=3
    set shiftwidth=3
endfunction
"command! Three call s:ThreeSpaces()
ca three call ThreeSpaces()

" set auto indenting
set autoindent
set smartindent " Enable smart-indent
set smarttab    " Enable smart-tabs
set cindent     " Use 'C' style program indenting

set wildmenu

set ruler   " Show row and column ruler information

"set confirm    " Prompt confirmation dialogs

"set showtabline=2  " Show tab bar
"set cmdheight=2    " Command line height

"set spell   " Enable spell-checking

"set virtualedit=all    " Enable free-range cursor
"set undolevels=1000 " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour

" Line break/wrapping
set showbreak=+++   " Wrap-broken line prefix
set linebreak       " Break lines at word (requires Wrap lines)
"set textwidth=100   " Line wrap (number of cols)

" Search settings
set showmatch   " Highlight matching brace
set hlsearch    " Highlight all search results
"set smartcase   " Enable smart-case search
"set ignorecase  " Always case-insensitive
"set incsearch   " Searches for strings incrementally

" fix pasting from clipboard
:set pastetoggle=<f5>

" Display line numbers
set number

" Autowrite a modified file any time comands are used to switch to another file, etc
set autowriteall

set updatetime=1000
autocmd CursorHoldI * silent w

augroup AutoWrite
    autocmd! BufLeave * :update
augroup END

" save with sudo permissions
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar> edit

" switching between splits
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>
nnoremap <A-Up> <C-W><C-K>
nnoremap <A-Down> <C-W><C-J>
nnoremap <A-Right> <C-W><C-L>
nnoremap <A-Left> <C-W><C-H>
" switching between buffers
nnoremap gb :ls<CR>:b<Space>
set hidden

map <C-c> "+y<CR>

" get rid of warnings when trying to move past first/last line
set belloff=all

" use console dialogs instead of popups for simple choices (in gVim, I think)
set guioptions=c

