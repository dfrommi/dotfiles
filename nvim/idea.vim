sourstractionFreeModstractionFreeModee

set clipboard+=ideaput

set ideajoin
set ideaput
set idearefactormode=keep

set showmode

" Don't use Ex mode, use Q for formatting.
map Q gq

" Find more examples here: https://jb.gg/share-ideavimrc

" set easymotion
map , <Plug>(easymotion-s2)

" Zen mode
map <c-z> <Action>(ToggleDistractionFreeMode)

nnoremap <Leader>r <Action>(Refactorings.QuickListPopupAction)

nnoremap ge <Action>(GotoNextError)
nnoremap gE <Action>(GotoPreviousError)

nnoremap [[ <Action>(MethodUp)
nnoremap ]] <Action>(MethodDown)

nnoremap <Leader>l <Action>(ReformatCode)
nnoremap <leader>o <Action>(OptimizeImports)

nnoremap <c-r> :action RecentFiles<CR>
nnoremap <leader>l :action RecentLocations<CR>
nnoremap <leader>h  :action LocalHistory.ShowHistory<CR>

nnoremap <c-/> :action FindInPath<CR>
nnoremap <c-a> :action GotoAction<CR>
nnoremap <c-f> :action GotoFile<CR>
nnoremap <leader>u :action FindUsages<CR>
nnoremap <leader>s :action GotoRelated<CR>
nnoremap <leader>h :action CallHierarchy<CR>
" nnoremap <leader>b :action ShowNavBar<CR>
nnoremap <c-s> :action FileStructurePopup<CR>
nnoremap <c-o> :action GotoSymbol<CR>
nnoremap gc :action GotoClass<CR>
nnoremap gi :action GotoImplementation<CR>
nnoremap gd :action GotToDeclaration<CR>
nnoremap gp :action GotToSuperMethod<CR>
nnoremap gt :action GotoTest<CR>
nnoremap gb :action Back<CR>
nnoremap gf :action Forward<CR>
