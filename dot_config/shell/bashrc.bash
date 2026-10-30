# 服务器上（通常没有 zsh）bash 的配置，效果尽量和 ~/.zshrc 一致。
# 不直接接管 ~/.bashrc：服务器上的 ~/.bashrc 往往有系统或集群写好的内容（conda、module 等），
# chezmoi 只在它末尾追加一行读取本文件（见仓库里的 modify_dot_bashrc）。

# 只对交互式 shell 生效；scp、rsync、ssh host cmd 这类非交互的情况直接跳过
[[ $- == *i* ]] || return

HISTFILE=~/.bash_history
HISTSIZE=100000
HISTFILESIZE=100000
# 不记录和上一条相同的命令（对应 zsh 的 HIST_SAVE_NO_DUPS）
HISTCONTROL=ignoredups
# 追加而不是覆盖历史文件，每条命令执行完立刻写入（对应 zsh 的 INC_APPEND_HISTORY）
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

shopt -s autocd

# vim 模式
set -o vi
# 上下键按前缀搜索历史；vim 模式下插入和命令两种状态都要绑定
for keymap in vi-insert vi-command; do
    bind -m $keymap '"\e[A": history-search-backward'
    bind -m $keymap '"\e[B": history-search-forward'
done
unset keymap
# 让vim在插入/命令模式下都能使用backspace
bind -m vi-command '"\C-?": backward-delete-char'

# 别名、代理、PATH 等和 zsh 共用的设置
source ~/.config/shell/common.sh

command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v starship >/dev/null && eval "$(starship init bash)"
