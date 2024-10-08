# Created by newuser for 5.9


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-.]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/tom/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=10000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# Key bindings
# Print current key bindings: bindkey
# List available key bindings: bindkey -l
# Interactively show pressed key when pressing any keys
bindkey "^[[H" beginning-of-line # HOME
bindkey "^[[F" end-of-line # END
bindkey "^[[3~" delete-char # DEL
bindkey "^[[3;5~" delete-word # CTRL+DEL - delete a whole word after cursor
bindkey "^H" backward-delete-word # CTRL+BACKSPACE - delete a whole word before cursor
bindkey "^[[1;5C" forward-word # CTRL+ARROW_RIGHT - move cursor forward one word
bindkey "^[[1;5D" backward-word # CTRL+ARROW_LEFT - move cursor backward one word
bindkey "^Z" undo # CTRL+Z
bindkey "^Y" redo # CTRL+Y

# Aliases
alias md="mkdir -p"
alias rd="rmdir"
alias -- -='cd "$OLDPWD"'
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias t="tere --filter-search"
alias hib="systemctl hibernate"

# Env Exports
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-match_002dwords_002dby_002dstyle
# Define how to match "words"; default mode is "normal" (alphanumerical + WORDCHARS)
# Default WORDCHARS are *?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
# Set the default editor for sudoedit or sudo -e
export VISUAL=kate
export EDITOR="$VISUAL"

# https://github.com/mgunyho/tere
tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

# If the internal history needs to be trimmed to add the current command line, setting this
# option will cause the oldest history event that has a duplicate to be lost before losing a
# unique event from the list. You should be sure to set the value of HISTSIZE to a larger
# number than SAVEHIST in order to give you some room for the duplicated events, otherwise
# this option will behave just like HIST_IGNORE_ALL_DUPS once the history fills up with unique
# events.
setopt HIST_EXPIRE_DUPS_FIRST
# When searching for history entries in the line editor, do not display duplicates of a line
# previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS
# If a new command line being added to the history list duplicates an older one, the older
# command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space. Only normal aliases (not
# global or suffix aliases) have this behaviour. Note that the command lingers in the internal
# history until the next command is entered before it vanishes, allowing you to briefly reuse
# or edit the line. If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt HIST_IGNORE_SPACE
# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS
# This option works like APPEND_HISTORY except that new history lines are added to the $HISTFILE
# incrementally (as soon as they are entered), rather than waiting until the shell exits.
setopt INC_APPEND_HISTORY

# Git status in prompt with the $(gitprompt) expansion
source /usr/share/zsh/scripts/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_TAG="%{$fg_bold[white]%}"

# Customizing the prompt
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# Either show hostname in the prompt "[tom@v330:~]" or not [tom:~]:
PROMPT='%B%F{magenta}[%n:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # without hostname
# PROMPT='%B%F{magenta}[%n@%m:%f%F{blue}%(4~|../|)%3~%f%b$(gitprompt)%B%F{magenta}]%f%b ' # with hostname
RPROMPT='%B%F{red}%(0?||Exit code: %?)%f%b'

# CTRL+ARROW_RIGHT   - partially accept suggestion up to the point that the cursor moves to
# ARROW_RIGHT or END - accept suggestion and replace contents of the command line buffer with the suggestion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# CTRL+T - paste the selected files and directories onto the command-line
# CTRL+R - paste the selected command from history onto the command-line
# ALT+C  - cd into the selected directory
source /usr/share/fzf/key-bindings.zsh
# Type ** and hit tab (eg. with the cd command; works with directories, files, process IDs, hostnames, environment variables)
source /usr/share/fzf/completion.zsh

# Sift through history for previous commands matching everything up to current cursor position.
# Moves the cursor to the end of line after each match.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # ARROW_UP
bindkey "^[[B" down-line-or-beginning-search # ARROW_DOWN

# Must go last (see https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### By Arthurmeade12
eval "$(zoxide init zsh)"
alias open='xdg-open'
alias rm=trash
alias cat=bat
alias 'cd'=z
alias ls=eza
#alias ls='exa -FHAloM@t modified --total-size --sort extension --color-scale all --color=auto --color-scale-mode gradient --no-user --icons auto --hyperlink --no-quotes --smart-group --group-directories-first --git --time-style iso'
alias du=dust
alias open=xdg-open
alias diff=delta
alias grep=rga
alias df=duf
alias vim=nvim
export PAGER=most
export EDITOR=kate
export PATH="${PATH}:${HOME}/.local/bin"
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

test_internet(){
while true
do
    if ! ping 127.217.10.206 -c 1 &>/dev/null
    then
        echo 'No connection. Waiting ...'
        sleep 2
        continue
    elif curl https://google.com &>/dev/null
    then
        echo 'Successful connection with DNS resolution.'
    else
        echo -e '`ping` works but `curl` does not. '\n'Check /etc/resolv.conf and maybe run `sudo resolvconf -u`.'
    fi
    break
done
}
bw_unlock(){
    local PASSWORD="$(kwallet-query -r bitwarden)"
    if [[ "$(bw login --check --raw)" = 'You are not logged in.' ]]
    then
        bw login arthurmeade12@gmail.com
    fi
}
developer_message(){
    curl -s http://www.developerexcuses.com/ | pup -c body center a | head -n 2 | tail -n 1 | tr '&#39;' \'
}
mouse(){
    case "$(tmux show-options)" in
    'mouse off')
        tmux set-option mouse on
        ;;
    'mouse on')
        tmux set-option mouse off
        ;;
    esac
}
enviro(){
    mcstatus robojoe.mooo.com json | jq
    MCRCON_HOST='robojoe.mooo.com' MCRCON_PORT='25787' MCRCON_PASS='4RWcPSr5Pddmxi' mcrcon
}

# Tmux aliases
s(){
    tmux neww -dn Spt ncspot
}
sn(){
    tmux neww -n Spt ncspot
}
b(){
	tmux neww -dn Btop btop
}
bn(){
	tmux neww -n Btop btop
}
u(){
    echo -n 'Press any key within 10 seconds to stop upgrade... or press enter to continue ...'
    read -k -t 10 KEY || return
    if [[ "${KEY}" != "" ]]
    then
        return
    fi
    sudo pacman -Syu
    paru
    printf "\a"
    echo 'Done!'
    sleep 3
}
a(){
	tmux attach || tmux
	tmux neww -d
	b
	s
	tmux killw -t 2
	tmux splitw -t 1 -h 'zsh -c u'
}

