### Exports ###
export LANG=ja_JP.UTF-8
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
export PATH=/Applications/MacVim.app/Contents/MacOS:$PATH
export PATH=/usr/local/bin:$PATH
export LC_ALL=ja_JP.UTF-8
export PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh

### Alias ###
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias mvim="reattach-to-user-namespace mvim --remote-tab-silent " #reattach~しないとtmuxからの起動でコピペが効かずにブチ切れる羽目になる
# alias vim="reattach-to-user-namespace mvim --remote-tab-silent "
alias ssh='nocorrect ssh'
alias ls='ls --color'

### ZSH ITSELF ###
## save zsh history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
## emacsライクなキーバインド
bindkey -e
## ビープを鳴らさない
setopt nobeep
## サスペンド中のプロセスと同じコマンドを実行した場合はリジューム
setopt auto_resume
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## 補完候補を一覧表示
setopt auto_list
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob
## TAB で順に補完候補を切り替える
setopt auto_menu
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
## =command を command のパス名に展開する
setopt equals
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort
## 出力時8ビットを通す
setopt print_eight_bit
## ヒストリを共有
setopt share_history
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## ディレクトリ名だけで cd
setopt auto_cd
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## スペルチェック
setopt correct
## Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt NO_flow_control
## コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
## コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
## ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
## history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
## 補完候補を詰めて表示
setopt list_packed
## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
## 小文字と大文字を区別しない
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
## shift+TABで補完候補を戻る
bindkey '^[[Z' reverse-menu-complete
## Ctrl+wの区切りを/にする
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
## Ctrl+Dでログアウトするのを防ぐ
setopt IGNOREEOF

### Virtualenvwrapper Config ###
# if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#     export WORKON_HOME=$HOME/.virtualenvs
#     source /usr/local/bin/virtualenvwrapper.sh
# fi
source /usr/local/bin/virtualenvwrapper_lazy.sh

### zplug ###
source ~/.zplug/zplug
zplug "chrissicool/zsh-256color", of:"zsh-256color.plugin.zsh"
# zplug "themes/ys", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "mafredri/zsh-async", on:sindresorhus/pure
zplug "sindresorhus/pure", nice:19
zplug load --verbose

### cdr ###
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# # 重複パスを登録しない
typeset -U path cdpath fpath manpath

#peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^@' peco-cdr

## 補完機能の強化
autoload -U compinit
compinit -C

# if type zprof > /dev/null 2>&1; then
#     zprof | less
# fi
