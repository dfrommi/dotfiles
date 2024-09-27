" Find more examples here: https://jb.gg/share-ideavimrc
"
" Find IntelliJ Action names:
"   Press Сmd-Shift-A and type 'IdeaVim: Track Action Ids'
"   Popup will then show actions when executed
"
" Reload config with Cmd-Shift-i


let mapleader=" "

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
map <leader>z <Action>(ToggleDistractionFreeMode)

map <leader><space> <Action>(GotoFile)
map <leader>/  <Action>(FindInPath)
map <leader>ss <Action>(FileStructurePopup)
map <leader>sS <Action>(GotoSymbol)
map <Leader>xx <Action>(ActivateProblemsViewToolWindow)

nmap s <Plug>(easymotion-s)
nnoremap <leader>fe :NERDTreeFocus<CR>

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


nmap gr   <Action>(FindUsages)
nmap gR   <Action>(CallHierarchy)
nmap gd   <Action>(GotoDeclaration)
nmap gD   <Action>(GotoTypeDeclaration)
nmap gI   <Action>(GotoImplementation)
nmap gt   <Action>(GotoTest)

nmap <Leader>ca <Action>(ShowIntentionActions)
nmap <Leader>cA <Action>(Refactorings.QuickListPopupAction)
nmap <Leader>cr <Action>(RenameElement)
nmap <Leader>cr <Action>(RenameFile)

nmap <Leader>cc <Action>(ReformatCode)<Action>(OptimizeImports)
nmap <Leader>cf <Action>(ReformatCode)
nmap <Leader>co <Action>(OptimizeImports)

nmap <Leader>*  <Action>(FindUsagesInFile)

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
