#!/usr/bin/env bash
set -Bboum pipefail
source /srv/minecraft/bin/config.sh
pushd "${MC_DIR}" || abort "\$MC_DIR does not exist or is not a directory."
help(){
    echo "Usage: ${0} <start|headless_start|sleepstart|stop|restart|attach|help>"
    exit "${1}"
}
eval_verb(){
    case "${1}" in
    'start'|'stop'|'attach') : ;;
    'help') help 0 ;;
    "*")    abort "\'$1\' is not a valid argument"
            help 2
            ;;
    esac
}
already_running(){
    pgrep -U "$(id -u)" java
}
sleeper_running(){
    already_running || pgrep -f "${MC_DIR}"/mcsleepingserverstarter-linux-x64
}
has_tmux(){
    tmux has -t "${TMUX_SESSION}" 2>/dev/null
}
no_tmux_error(){
    abort "The tmux session is not running" && exit 1
}
JAR="$(find "${MC_DIR}" -maxdepth 1 -name "*.jar")"
EXEC=("bash -c \"DISPLAY=:0 exec -a Minecraft_Server archlinux-java-run --max ${MAXJAVA} --min ${MINJAVA} -- ${JAVAOPTS} ${JAR} ${OPTS}\"")
export JAR EXEC
[[ "$(whoami)" != 'minecraft' ]] && abort "Must be run as 'minecraft' user" && exit 1
case "${#}" in
0)  help 2 ;;
1)  eval_verb "${1}" ;;
2)  eval_verb "${1}"
    export MC_DIR="${2}" ;;
3)  echo 'Too many arguments' ;;
esac
case "${1}" in
'start')
    if ! has_tmux
    then
        tmux new -dDn 'Trash' -s "${TMUX_SESSION}"
        export KILLW='true'
    fi
    already_running || tmux neww -dPn 'Minecraft' -c "${MC_DIR}" -t "${TMUX_SESSION}" "${EXEC[*]}"
    [[ "${KILLW}" ]] && tmux killw -t "${TMUX_SESSION}":'Trash'
    out "Started the Minecraft Server!"    
;;
'sleepstart')
    set -x
    if ! has_tmux
    then
        tmux new -dDn 'Trash' -s "${TMUX_SESSION}"
        export KILLW='true'
    fi
    TEMP="$(mktemp)"
    sed -e '10d' -e "9 a minecraftCommand: ${EXEC[*]}" "${MC_DIR}"/sleepingSettings.yml > "${TEMP}"
    cat "${TEMP}" > "${MC_DIR}"/sleepingSettings.yml
    sleeper_running || tmux neww -dPn 'Minecraft' -c "${MC_DIR}" -t "${TMUX_SESSION}" "${MC_DIR}/mcsleepingserverstarter-linux-x64"
    set +x
    [[ "${KILLW}" ]] 2>/dev/null && tmux killw -t "${TMUX_SESSION}":'Trash' # 2>/dev/null gets rid of 'unbound var' message
    out "Started program to wait for clients!"
    ;;
'stop')
    has_tmux || no_tmux_error
    if already_running
    then
        MCRCON_HOST=localhost mcrcon -w 5 "say Server is stoppping!" save-all stop
    elif sleeper_running
    then
        tmux send -t "${TMUX_SESSION}:Minecraft" 'quit
        '
    else
        warn 'The server is not running.'
        exit 1
    fi
    out "Stopped the Minecraft Server!"
    ;;
'attach')
    has_tmux || no_tmux_error
    tmux attach -t "${TMUX_SESSION}"
    tmux selectw -t 'Minecraft'
    ;;
'restart')
    # For interactive restart, not spigot restart.
    exec "${0}" 'stop'
    exec "${0}" 'start'
    out "Retstarted the Server!"
    ;;
'headless_start')
    if has_tmux
    then
        tmux new -dDn 'Trash' -s "${TMUX_SESSION}"
        export KILLW='true'
    fi
    "${EXEC[@]}"
    ;;
esac
