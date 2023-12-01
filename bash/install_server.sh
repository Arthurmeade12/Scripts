#!/usr/bin/env bash
# Dependencies: Bash,
MINIMUM_BASH_VERSION='1' # May change later.
out(){
    printf "\033[34;1m==>\033[0m %s\033[0m\n" "${@}"
}
error(){
     printf "\033[31;1m==>\033[0m \033[1m%s\033[0m\n" "${@}"
}
qq(){
    local VAR="${2}"
    local MESSAGE="${1}"
    printf "\033[33;1m==>\033[0m %s\033[0m" "${MESSAGE}"
    #shellcheck disable=SC2229
    read -r "${VAR}"
    #shellcheck disable=SC2163
    export "${VAR}"
}
out "Welcome to Arthur's Minecraft Server Installer!"
printf "\n"
if [[ "${BASH_VERSINFO[0]}" -lt "${MINIMUM_BASH_VERSION}" ]]
then
    out "This script needs at least Bash ${MINIMUM_BASH_VERSION} to run."
    exit 4
fi
# Java check heavily inspired / taken and modified from `gradlew`
if [[ -n "${JAVA_HOME}" ]]
then
    JAVACMD="${JAVA_HOME}/bin/java"
    if [[ ! -x "${JAVACMD}" ]]
    then
        error "ERROR: JAVA_HOME is set to an invalid directory: ${JAVA_HOME}
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
        exit 3
    fi
else
    JAVACMD="java"
    if ! which java >/dev/null 2>&1
    then
        error "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
        exit 4
    fi
fi

out 'Please choose a folder for your server. It is recommended to be empty. '
qq 'Make a new folder or choose a folder? (make|choose) : ' FOLDER_METHOD
case "${FOLDER_METHOD}" in
'make')
    until [[ -d "${FOLDER}" ]]
    do
        qq 'Folder : ' 'FOLDER'
        mkdir -p "${FOLDER}" || \
        error "That's not a valid folder name." # Should almost never happen.
    done
    ;;
'choose')
    out 'On macOS, you can drag a folder onto this window. '
    until [[ -d "${FOLDER}" ]]
    do
        qq 'Folder : ' 'FOLDER'
        if [[ ! -d "${FOLDER}" ]]
        then
            # Throw error and fall back to creating the folder.
            error "Folder ${FOLDER} does not exist, creating it."
            mkdir -p "${FOLDER}" || \
            error "That's not a valid folder." # Should almost never happen.
        fi
        if [[ ! -r "${FOLDER}" ]] || [[ ! -w "${FOLDER}" ]]
        then
            error 'The folder is not readable and/or writable.'
            error 'Fix the permissions, or choose a different folder.'
            exit 2
            # TODO: Auto-fix permissions?
        fi
    done
    ;;
esac
FOLDER="$(readlink -f "${FOLDER}")" # Express ${FOLDER} as an absolute path.
out "Folder: ${FOLDER}"
out 'What Minecraft version do you want to play (no snapshots!) ?'
qq 'Minecraft version : ' MINECRAFT_VERSION
case "${MINECRAFT_VERSION}" in
1.[7-20]) true ;; ## Check DOES NOT WORK right now. TODO.
esac

