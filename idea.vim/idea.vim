" Find more examples here: https://jb.gg/share-ideavimrc

let mapleader=" "

"source ~/.config/idea.vim/init.vim

set clipboard+=unnamed
set clipboard+=ideaput

set scrolloff=10
set linenumber
set showmode
set showcmd
set visualbell

set ideajoin
set ideaput
set ideastatusicon=gray
set showmode

set ignorecase
set smartcase
set incsearch
set hlsearch

""" Plugins
set commentary
set easymotion
set NERDTree
set which-key
" set surround
" set argtextobj

" TODO
" - Duplicate line in normal and insert mode also in plain vim = M-d
" - Movements also in insert-mode

" Zen mode
" map <c-z> <Action>(ToggleDistractionFreeMode)
map <leader>fs <Action>(FileStructurePopup)
map <leader>ff <Action>(GotoFile)

nmap s <Plug>(easymotion-s)
nnoremap <leader>ft :NERDTreeFocus<CR>

" buffer switch
map <leader>fb <Action>(RecentFiles)
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap <leader>` <Action>(PreviousTab)

" Move lines/selection around
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <ESC>:m .+1<CR>==gi
inoremap <A-k> <ESC>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nmap ]e <Action>(GotoNextError)
nmap [e <Action>(GotoPreviousError)

nnoremap [m <Action>(MethodUp)
nnoremap ]m <Action>(MethodDown)

nmap gD <Action>(GotoDeclaration)
nmap gy <Action>(GotoTypeDeclaration)
nmap gI <Action>(GotoImplementation)

"
" TODO
"

" nmap <Leader><Leader> <Action>(ShowIntentionActions)
nmap <Leader>r <Action>(RenameElement)
nmap <Leader>R <Action>(Refactorings.QuickListPopupAction)
nmap <Leader>u <Action>(FindUsages)
nmap <Leader>U <Action>(FindUsagesInFile)
nmap <Leader>h <Action>(CallHierarchy)

nmap <Leader>cc <Action>(ReformatCode)<Action>(OptimizeImports)
nmap <Leader>cf <Action>(ReformatCode)
nmap <Leader>co <Action>(OptimizeImports)

nmap <Leader>/ <Action>(FindInPath)

"
" MOVEMENTS
"
" nmap <Leader>gg <Action>(RecentFiles)

" nmap <Leader>gh <Action>(Back)
" nmap <Leader>gl <Action>(Forward)
" nmap <Leader>gH <Action>(JumpToLastChange)
" nmap <Leader>gL <Action>(JumpToNextChange)

" nmap <Leader>gK <Action>(GotoSuperMethod)
" nmap <Leader>gJ <Action>(GotoImplementation)

" <Leader>* ???

nmap <Leader>gt <Action>(GotoTest)

" nmap <Leader>gm <Action>(FileStructurePopup)

"
" EXEXUTE
"
" x = execute
" X = execute in debug mode
nmap <Leader>xx <Action>(Rerun)
nmap <Leader>x/ <Action>(RunConfiguration)
nmap <Leader>X/ <Action>(ChooseDebugConfiguration)
nmap <Leader>xc <Action>(RunClass)
nmap <Leader>Xc <Action>(DebugClass)
" kill
nmap <Leader>xk <Action>(Stop)

"
" MISC FIXES
"

" Keep selection and stay in visual mode on (un)indent
vnoremap < <gv
vnoremap > >gv

" forward-delete should not add to default register
nmap <Del> "_dl
nmap x "_dl
