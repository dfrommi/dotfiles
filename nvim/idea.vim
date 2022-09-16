" Find more examples here: https://jb.gg/share-ideavimrc

source ~/.config/nvim/init.vim

set clipboard+=ideaput

set ideajoin
set ideaput
set ideastatusicon=gray
set showmode

" Don't use Ex mode, use Q for formatting.
map Q gq

" set easymotion
" map , <Plug>(easymotion-s2)

"
" TODO
" - Duplicate line in normal and insert mode also in plain vim = M-d
" - Movements also in insert-mode

" Zen mode
map <c-z> <Action>(ToggleDistractionFreeMode)
map <M-m> <Action>(FileStructurePopup)

" nmap <Leader><Leader> <Action>(ShowIntentionActions)
nmap <Leader>r <Action>(RenameElement)
nmap <Leader>R <Action>(Refactorings.QuickListPopupAction)
nmap <Leader>u <Action>(FindUsages)
nmap <Leader>U <Action>(FindUsagesInFile)
nmap <Leader>h <Action>(CallHierarchy)

"
" CODE
"
nmap <Leader>cc <Action>(ReformatCode)<Action>(OptimizeImports)
nmap <Leader>cf <Action>(ReformatCode)
nmap <Leader>co <Action>(OptimizeImports)

nmap <Leader>/ <Action>(FindInPath)

"
" MOVEMENTS 
"
" nmap <Leader>gg <Action>(RecentFiles)

nmap <Leader>ge <Action>(GotoNextError)
nmap <Leader>gE <Action>(GotoPreviousError)

nmap <Leader>gh <Action>(Back)
nmap <Leader>gl <Action>(Forward)
nmap <Leader>gH <Action>(JumpToLastChange)
nmap <Leader>gL <Action>(JumpToNextChange)

nmap <Leader>gk <Action>(MethodUp)
nmap <Leader>gj <Action>(MethodDown)
nmap <Leader>gK <Action>(GotoSuperMethod)
nmap <Leader>gJ <Action>(GotoImplementation)

" <Leader>* ???
nmap <Leader>gd <Action>(GotoDeclaration)
nmap <Leader>gt <Action>(GotoTest)

" nmap <Leader>ga <Action>(GotoAction)
" nmap <Leader>gs <Action>(GotoSymbol)
" nmap <Leader>gc <Action>(GotoClass)
" nmap <Leader>gf <Action>(GotoFile)
" nmap <Leader>gF <Action>(ShowNavBar)

nmap <Leader>gm <Action>(FileStructurePopup)

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

