filetype plugin indent on

syntax on
try
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
    tnoremap <Esc><Esc> <C-\><C-n> 
else
    " Standard vim specific commands
endif

" show existing tab with 4 spaces width
set tabstop=4

" indent with 4 spaces
set shiftwidth=4
" change tabs to spaces
set expandtab

" set auto indenting
set autoindent
set cindent

" fix pasting from clipboard
:set pastetoggle=<f5>

"display line numbers
set number

" autowrite files
set autowriteall

set updatetime=1000
autocmd CursorHoldI * silent w

augroup AutoWrite
    autocmd! BufLeave * :update
augroup END

" switching between splits
nnoremap <A-Down> <C-W><C-J>
nnoremap <A-Up> <C-W><C-K>
nnoremap <A-Right> <C-W><C-L>
nnoremap <A-Left> <C-W><C-H>
" switching between buffers
nnoremap gb :ls<CR>:b<Space>
set hidden

map <C-c> "+y<CR>

" Commenting blocks of code
" comment with ,cc; uncomment with ,cu
augroup comment
    autocmd!
    autocmd FileType c,cpp,java,scala             let b:commentleader='// '
    autocmd FileType sh,ruby,python,conf,fstab    let b:commentleader='# '
    autocmd FileType tex                          let b:commentleader='% '
    autocmd FileType mail                         let b:commentleader='> '
    autocmd FileType vim                         let b:commentleader='" '
augroup END
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:commentleader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:commentleader,'\/')<CR>//e<CR>:nohlsearch<CR>

" get rid of warnings when trying to move past first/last line
set belloff=all

" use console dialogs instead of popups for simple choices (in gVim, I think)
set guioptions=c

