" Documentation available here :https://github.com/JetBrains/ideavim
" IDE Actions -- List all available with :actionlist

set number
set ignorecase
set smartcase

" Vanilla Keymaps
noremap <D-v> <C-v>

let mapleader=" "

" Need to only set these in the editor itself
" This way it works with Fuzzy Finder and Completion
" noremap <D-h> <Left>
" noremap <D-j> <Down>
" noremap <D-k> <Up>
" noremap <D-l> <Right>

" My remapping for moving far vertically and horizontally
noremap H ^
noremap J 020jzz
noremap K 020kzz
noremap L $

" Only paste what we "yank", not the deleted text
noremap p "0p

" Make x, only while in visual mode, cut text into register 0
vnoremap x "0x

" Need to set these in the editor itself as well
" noremap <D-p> $Paste
" noremap <D-y> $Copy
" noremap <D-x> $Cut

" Intuitive tab indentation
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" Write content quickly
map <Leader>w <Action>(SaveDocument)
map <Leader>W <Action>(SaveAll)

" Write content quickly
map <Leader>e <Action>(CloseContent)
map <Leader>E <Action>(CloseAllToTheRight)

" Switch between windows quickly
noremap <Leader>h <C-w>h
noremap <Leader>j <C-w>j
noremap <Leader>k <C-w>k
noremap <Leader>l <C-w>l

" Easier redo command
noremap R <C-r>

" Easier way to add or subtract one from a number
noremap <Leader>i <C-a>
noremap <Leader>I <C-x>

" Quickly Select Tabs
map <Leader>oa <Action>(GoToTab1)
map <Leader>os <Action>(GoToTab2)
map <Leader>od <Action>(GoToTab3)
map <Leader>of <Action>(GoToTab4)
map <Leader>og <Action>(GoToTab5)

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

" Searching For Words
set hlsearch
noremap <Leader>n :noh<CR>
noremap gn *N

" LSP "Actions" and Diagnostic Actions
map gd <Action>(GotoImplementation)
map gD <Action>(GotoTypeDeclaration)
map gr <Action>(GotoDeclaration)
map <Leader>aj <Action>(GotoNextError)
map <Leader>ak <Action>(GotoPreviousError)
map <Leader>ao <Action>(ShowErrorDescription)
map <Leader>ah <Action>(QuickJavaDoc)
map <Leader>ar <Action>(RenameElement)

" JetBrains specific actions
map <Leader>af <Action>(ShowIntentionActions)
map <Leader>ai <Action>(CodeInspection.OnEditor)

" Toggle certain HUD display settings
map <Leader>dl :set number!<CR>
map <Leader>dr :set relativenumber!<CR>
map <Leader>dd <Action>(ToggleDistractionFreeMode)

" Git Gutter Actions
map <Leader>go <Action>(VcsShowCurrentChangeMarker)
map <Leader>gj <Action>(VcsShowNextChangeMarker)
map <Leader>gk <Action>(VcsShowPrevChangeMarker)
map <Leader>gr <Action>(Vcs.RollbackChangedLines)
map <Leader>gd <Action>(Vcs.ShowDiffChangedLines)

" NERDTree
set NERDTree
map <Leader>to :NERDTree<CR>
map <Leader>tp :NERDTreeFind<CR>
map <Leader>tq :NERDTreeClose<CR>

" Easy Motion
set easymotion
map <Leader>;j <Plug>(easymotion-j)
map <Leader>;k <Plug>(easymotion-k)
map ; <Plug>(easymotion-bd-f2)