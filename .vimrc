set nocompatible
filetype off

"---------------------------
"augroup&autocmd Settings.
"---------------------------
augroup MyVimrc
  autocmd!
augroup END

"---------------------------
"Neobundle Settings.
"---------------------------
" bundleで管理するディレクトリを指定
set runtimepath+=~/.vim/bundle/neobundle.vim/
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundleLazy 'davidhalter/jedi-vim', {
\   'autoload': {'filetypes': ['python']}
\}
NeoBundle 'scrooloose/syntastic'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'tyru/caw.vim.git'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'surround.vim'
NeoBundle 'lambdalisue/vim-pyenv'
NeoBundleLazy "jmcantrell/vim-virtualenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}


call neobundle#end()

" Required:
filetype plugin indent on

" Ask if there are plugins that are not installed yet
NeoBundleCheck

"-------------------------
"Jedi.vim settings
"-------------------------
"docstringは表示しない
autocmd MyVimrc FileType python setlocal completeopt-=preview
let g:jedi#rename_command = '<Leader>R'

"-------------------------
"Vim-Indent Guides settings
"-------------------------
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

"-------------------------
"Vimfiler settings
"-------------------------
"vimfilerをデフォルトのファイラーとして使う
let g:vimfiler_as_default_explorer = 1
"現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
"Disable Safe Mode
let g:vimfiler_safe_mode_by_default = 0

"-------------------------
"Lightline.vim settings
"-------------------------
set laststatus=2
set t_Co=256
let g:lightline = {
      \ 'colorscheme': 'hybrid',
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

"-------------------------
" QuickRun settings
"-------------------------
" runner/vimproc/updatetime で出力バッファの更新間隔をミリ秒で設定できます
" updatetime が一時的に書き換えられてしまうので注意して下さい
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error' : 'buffer',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ }

"-------------------------
"Startify settings
"-------------------------
let g:startify_bookmarks = [
    \ '~/.vimrc',
    \ '~/.gvimrc',
    \ '~/.zshrc',
    \ ]

"-------------------------
"Unite.vim settings
"-------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一u
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
let g:unite_source_history_yank_enable = 1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>	
" ウィンドウを分割して開く
autocmd MyVimrc FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
autocmd MyVimrc FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
autocmd MyVimrc FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
autocmd MyVimrc FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
autocmd MyVimrc FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
autocmd MyVimrc FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"-------------------------
"Caw.vim settings
"-------------------------
nmap <C-K> <Plug>(caw:tildepos:toggle)
vmap <C-K> <Plug>(caw:tildepos:toggle)

"-------------------------
"Syntastic settings
"-------------------------
let g:syntastic_python_checkers = ["pyflakes"]

"--------------------------
"Vim settings
"--------------------------
syntax on
set encoding=utf8
set fileencoding=utf-8
"スクロールするときに下が見えるようにする
set scrolloff =5
" .swapファイルを作らない
set noswapfile
" バックアップファイルを作らない
set nowritebackup
" バックアップをしない
set nobackup
" バックスペースで各種消せるようにする
set backspace=indent,eol,start
" ビープ音を消す
set visualbell t_vb=
" OSのクリップボードを使う
set clipboard+=unnamed
set clipboard=unnamed
set clipboard+=autoselect
" 不可視文字を表示
set list
" 行番号を表示
set number
" 右下に表示される行・列の番号を表示する
set ruler
" compatibleオプションをオフにする
set nocompatible
" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline
" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=1
" ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set wrap
" 入力されているテキストの最大幅を無効にする
set textwidth=0
" 不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" インデントをshiftwidthの倍数に丸める
set shiftround
" 補完の際の大文字小文字の区別しない
set infercase
" 小文字の検索でも大文字も見つかるようにする
set ignorecase
" ただし大文字も含めた検索の場合はその通りに検索する
set smartcase
" インクリメンタルサーチを行う
set incsearch
" 検索結果をハイライト表示
set hlsearch
" コマンド、検索パターンを10000個まで履歴に残す
set history=10000
" マウスモード有効
set mouse=a
" コマンドを画面最下部に表示する
set showcmd
" 新しく開く代わりにすでに開いてあるバッファを開く
set switchbuf=useopen
" バッファを閉じる代わりに隠す
set hidden
" 0埋めの文字でCtrl+aする際に10進数も認識させる
set nf=
" 画面に表示されるタブ幅
set tabstop=4
" タブをスペース展開
set expandtab
" インデント時のスペース数
set shiftwidth=4
" タブが押された場合にtabstopでなく、shiftwidthの数だけインデントする
set smarttab
" 自動インデント
set autoindent
" 右に分割
set splitright

"--------------------------
"Key Bindings
"--------------------------
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" 表示行単位で上下移動するように
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
" 逆に普通の行単位で移動したい時のために逆の map も設定しておく
nnoremap gj j
nnoremap gk k
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"--------------------------
"Python Settings
"--------------------------
augroup Python
    autocmd!
    autocmd FileType python setl autoindent
    autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
    autocmd BufNewFile *.py 0r $HOME/.vim/template/python.txt
augroup END


"--------------------------
"Appearance Settings
"--------------------------
let g:hybrid_use_Xresources = 1
set background=dark
colorscheme hybrid

