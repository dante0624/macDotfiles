" Documentation available here :https://github.com/JetBrains/ideavim

set number

" Vanilla Keymaps
noremap <D-v> <C-v>
let mapleader=" "

" Quicker navigation of single file
noremap H ^
noremap J 020jzz
noremap K 020kzz
noremap L $

" Split screen navigation
noremap <M-h> <C-w>h
noremap <M-j> <C-w>j
noremap <M-k> <C-w>k
noremap <M-l> <C-w>l

" Need to only set these in the editor itself
" This way it works with Fuzzy Finder and Completion
" noremap <D-h> <Left>
" noremap <D-j> <Down>
" noremap <D-k> <Up>
" noremap <D-l> <Right>

" Paste from register 0 instead of the unnamed register, such that we only paste what we yank
noremap p "0p

" Make x, only while in visual mode, cut text into register 0
vnoremap x "0x

" Intuitive tab indentation
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" Easier redo command
noremap R <C-r>

" Easier way to add one to a number
map <Leader>a <C-a>

" IDE Actions -- List all available with :actionlist
map <Leader>w <Action>(SaveDocument)
map <Leader>W <Action>(SaveAll)
map <Leader>e <Action>(CloseContent)
map <Leader>E <Action>(CloseAllToTheRight)

" Quickly Select Tabs
map <D-a> <Action>(GoToTab1)
map <D-s> <Action>(GoToTab2)
map <D-d> <Action>(GoToTab3)
map <D-f> <Action>(GoToTab4)
map <D-g> <Action>(GoToTab5)

" Fuzzy Finder Actions
map <Leader>f <Action>(GotoFile)
map <leader>F <Action>(FindInPath)

" Comment Lines
nmap C v<Action>(CommentByLineComment)v
vmap C <Action>(CommentByLineComment)
vmap <Leader>c <Action>(CommentByBlockComment)

" Cycle Through Tabs
nmap <Tab> <Action>(NextTab)
nmap <S-Tab> <Action>(PreviousTab)

" Folding
map zc <Action>(CollapseRegion)
map zo <Action>(ExpandRegion)
map zR <Action>(ExpandAllRegions)
map za <Action>(ExpandCollapseToggleAction)

" LSP and Diagnostic Actions
map <Leader>lr <Action>(RenameElement)
map gd <Action>(GotoImplementation)
map gD <Action>(GotoTypeDeclaration)
map gr <Action>(GotoDeclaration)
map <Leader>lh <Action>(QuickJavaDoc)
map <Leader>li <Action>(CodeInspection.OnEditor)
map <Leader>dj <Action>(GotoNextError)
map <Leader>dk <Action>(GotoPreviousError)
map <Leader>do <Action>(ShowErrorDescription)

" Toggle the heads-up-display around the main editor
map <Leader>h <Action>(ToggleDistractionFreeMode)

" Git Gutter Actions
map <Leader>gj <Action>(VcsShowNextChangeMarker)
map <Leader>gk <Action>(VcsShowPrevChangeMarker)
map <Leader>gr <Action>(Vcs.RollbackChangedLines)
map <Leader>gd <Action>(Vcs.ShowDiffChangedLines)

" EasyMotion Plugin
set easymotion
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>; <Plug>(easymotion-bd-f)

" NERDTree
set NERDTree
map <Leader>to :NERDTree<CR>
map <Leader>tp :NERDTreeFind<CR>
map <Leader>tq :NERDTreeClose<CR>