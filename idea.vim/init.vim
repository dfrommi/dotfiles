let mapleader=" "

set clipboard+=unnamed

set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a

set ignorecase
set smartcase
set incsearch
set hlsearch

set number
set relativenumber

set visualbell
set noerrorbells

set scrolloff=5

" Install plugin manager with
"   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then run nvim and install plugin with
"   :PlugInstall

" "call plug#begin()

" TODO 
"   https://github.com/nvim-telescope/telescope.nvim
"   https://github.com/folke/trouble.nvim


" "Plug 'preservim/nerdtree'
" "Plug 'preservim/tagbar'
" "Plug 'vim-airline/vim-airline'
" "Plug 'arcticicestudio/nord-vim'

" "Plug 'tpope/vim-surround'
" "Plug 'tpope/vim-commentary'
" "Plug 'easymotion/vim-easymotion'

" "Plug 'dag/vim-fish'

" "call plug#end()

" "colorscheme nord

" Status bar
" set noshowmode
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#tab_min_count = 2
" let g:airline#extensions#tabline#buffer_min_count = 2
" let g:airline_powerline_fonts = 1

" nnoremap <C-f> :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>

" 'structure'
" nnoremap <C-s> :TagbarToggle<CR> 

" Easymotion (jump)
" let g:EasyMotion_do_mapping = 0 " Disable default mappings
" let g:EasyMotion_smartcase = 1
" nnoremap <leader><leader> <Plug>(easymotion-s)

" hi EasyMotionShade  ctermbg=none ctermfg=blue
" hi EasyMotionTarget ctermbg=none ctermfg=white cterm=bold
" hi EasyMotionTarget2First ctermbg=none ctermfg=white cterm=bold
" hi EasyMotionTarget2Second ctermbg=none ctermfg=white cterm=bold

" Redo
" "nnoremap U <C-R>

" forward-delete should not add to default register
" nmap x "_dl
" nmap <Del> "_dl

" buffer switch
" TODO buffer search-list with CMD-E (like IntelliJ)
" nnoremap <C-[> :bprevious<CR>
" nnoremap <C-]> :bnext<CR>
 
" Bring back join lines (removed in previous mapping)
nnoremap <leader>j J

" Move lines/selection around
" TODO use IntelliJ's CMD-SHIFT-UP/DOWN, but CMD (map-modifier D aka.
" super-key not working in Kitty)
" nnoremap <C-j> :m .+1<CR>==
" nnoremap <C-k> :m .-2<CR>==
" inoremap <C-j> <ESC>:m .+1<CR>==gi
" inoremap <C-k> <ESC>:m .-2<CR>==gi
" vnoremap <C-j> :m '>+1<CR>gv=gv
" vnoremap <C-k> :m '<-2<CR>gv=gv
"
" Window management
" nnoremap <c-\> :vsplit<CR>
" nnoremap <c--> :split<CR>
" nnoremap <c-=> :only<CR>

" Keep selection and stay in visual mode on (un)indent
" vnoremap < <gv
" vnoremap > >gv

