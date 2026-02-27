# =========================================================
# file: .zshrc
# encoding: utf-8
# date: 2026-02-27 13:46:01
# =========================================================

# 1. 历史记录配置
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt APPEND_HISTORY          # 追加历史记录而非覆盖
setopt HIST_IGNORE_DUPS        # 不记录连续重复的命令
setopt HIST_IGNORE_SPACE       # 忽略空格开头的命令
setopt SHARE_HISTORY           # 在多个终端间共享历史记录

# 2. 启用自动补全系统
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # 启用不区分大小写的补全

# 3. 颜色配置
autoload -U colors && colors

# 4. 配置 ls 颜色
# 如果系统有 dircolors 命令，则使用它
if (( $+commands[dircolors] )); then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    # Mac 或其他系统的备选
    export CLICOLOR=1
    export LSCOLORS=Gxfxcxdxbxegedabagacad
    alias ls='ls -G'
fi

# 5. 别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# 6. Prompt 设置
# 开启提示符变量替换功能
setopt PROMPT_SUBST

# 获取 Debian chroot 标识
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# %B...%b      : 粗体开始/结束
# %F{green}    : 字体颜色绿色
# %n           : 用户名
# %m           : 主机名
# %~           : 当前目录
# %(!.#.$)     : 如果是特权用户显示 #，否则显示 $
PROMPT='${debian_chroot:+($debian_chroot)}%B%F{green}%n@%m%f%b:%B%F{blue}%~%f%b%(!.#.$) '

# 设置终端窗口标题
case "$TERM" in
xterm*|rxvt*)
    precmd() {
        print -Pn "\e]0;%n@%m: %~\a"
    }
    ;;
esac

# 7. 键盘绑定，让 Home/End/Delete 键在 zsh 中正常工作
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word

# 如果有 .bash_aliases 文件，尝试加载它
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# 8. 代理配置 
PROXY_HOST="127.0.0.1"
PROXY_PORT="1082"

# 开启代理
alias proxy="
    export http_proxy='http://${PROXY_HOST}:${PROXY_PORT}'
    export https_proxy='http://${PROXY_HOST}:${PROXY_PORT}'
    export all_proxy='socks5://${PROXY_HOST}:${PROXY_PORT}'
    echo 'Proxy Activated for this terminal (Host: ${PROXY_HOST}:${PROXY_PORT}). Type \"unproxy\" to deactivate.'
"

# 关闭代理
alias unproxy="
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo 'Proxy Deactivated for this terminal.'
"

# 9. 拦截特定命令的错误并输出提示

## 9.1 git clone
git() {
    # 执行真实的 git 命令
    command git "$@"
    local exit_code=$?

    # 条件 1. 执行失败 2. 是 clone 命令 3. 包含了默认的 github.com 域名
    if [[ $exit_code -ne 0 && "$1" == "clone" && "$*" == *"git@github.com"* ]]; then
        # 输出硬编码的提示信息
        echo -e "\n======================================================="
        echo -e "💡 提示 (来自 .zshrc):"
        echo -e "如果 SSH 权限被拒绝，可能是因为你忘记替换 GitHub 的 SSH 别名了。请使用以下别名重试："
        echo -e "  👉 工作账号: git@github-work"
        echo -e "  👉 个人账号: git@github-personal"
        echo -e ""
        echo -e "例如: git clone git@github-personal:torvalds/linux.git"
        echo -e ""
        echo -e "使用 cat ~/.ssh/config 查看 SSH 配置，通过检查 HOST 别名和对应的 IdentityFile 来确认设置。"
        echo -e "=======================================================\n"
    fi

    # 传递原始退出码
    return $exit_code
}