#!/usr/bin/env bash
SOURCE=${SOURCE:='/srv/minecraft/bin/config.sh'}
NOHASHUPDATE=${NOHASHUPDATE:='false'} # If true, will download every time if there's an update or not.
INTOUPDATE=${INTOUPDATE:='false'} # If true, will download updates into the 'update' folder.
. "${SOURCE}"
out(){
  if [[ -t 1 ]]
  then
    echo -e "$(tput setaf 4)${BOLD}==>${RESET} $(tput setaf 15)${*} ${RESET}"
  else
    echo "$@"
  fi
}
warn(){
	local -r YELLOW="$(tput setaf 3)"
	if [[ -t 1 ]]
	then
		for ARG in "$@"; do
			echo -e "${YELLOW}${BOLD}==>${RESET} ${YELLOW}WARNING: ${WHITE}${ARG} ${RESET}"
		done
    else
        echo "$@"
	fi
}
abort(){
    if [[ -t 1 ]]
    then
	local -r RED="$(tput setaf 1)"
        echo -e "$(tput setaf 5)${BOLD}==> ${RED}${*} ${RESET}"
        echo "${RED}Aborting ... ${RESET}"
    else
        echo -e "$*\nAborting ..."
    fi
}
badfile(){
    warn "Download failed, or file did not match hash. \nTry manually downloading or restoring file from ~/.local/share/trash/files ."
}
intoupdate(){
  [[ "${INTOUPDATE}" = 'true' ]] && (
    if [[ "$(basename "$(pwd)")" = 'update' ]]
    then
      popd
    else
      pushd ./update
    fi
  )
}
skipnohashupdate(){
  if [[ "${NOHASHUPDATE}" = 'false' ]]
  then
    out "Skipping ${1} because \$NOHASHUPATE = false, and ${1} does not have a hash."
    return 1
  fi
}
consturl(){
  skipnohashupdate "${1}" || return 0
  intoupdate
  if curl -JLO# "${2}"
  then
    out "Successfully downloaded latest version of ${1}!"
  else
    warn "Unable to download. Check your internet connection. "
  fi
  intoupdate
}
githubeval(){
  skipnohashupdate "${1}" || return 0
  local REPO="${1}"
  local NAME="${1#*/}"
  local JQCOMMAND=".[].assets[] | select(startswith(\"${2%'*.jar'}\") | .browser_download_url)"
  intoupdate
  if curl -JLO# "$(gh api --header 'Accept: application/vnd.github+json' --method GET "/repos/${REPO}/releases" -F per_page=1 | jq -r '.[].assets[].browser_download_url')"
  then
    out "Successfully downloaded latest version of ${1}!"
  else
    warn "Unable to download. Check your internet connection. "
  fi
  intoupdate
}
geysereval(){
    intoupdate
	local FILE="$(find . -maxdepth 1 -name "${2}" 2>/dev/null)"
	if [[ -z "${FILE}" ]]
	then
		local FILE="$(mktemp)"
		touch "${FILE}"
	fi
	local APIURL="https://download.geysermc.org/v2/projects/${1}/versions/latest/builds/latest"
	local NAME="${1^}"
	if [[ "$(curl --silent "${APIURL}" | jq -r .downloads.spigot.sha256)" = "$(sha256sum "${FILE}" | cut -d " " -f 1 )" ]]
	then
		out "${NAME} is up to date!"
	else
		curl -#o "$(curl "${APIURL}" | jq -r .downloads.spigot.name)" "${APIURL}"/downloads/spigot
		out "Updated ${NAME}!"
	fi
	intoupdate
}
mreval(){
    mrdown(){
        curl -X POST --silent "${1}" -H "Content-Type: application/json" --data-binary @- <<DATA
{
  "loaders": [
      "paper",
      "purpur"
  ],
  "game_versions": [
    "1.19.4",
    "1.19.3",
    "1.19.2",
    "1.19.1"
  ],
  "algorithm":"sha1"
}
DATA
    }
    intoupdate
    local FILE="$(find . -maxdepth 1 -name "${2}" 2>/dev/null)"
    if [[ -z "${FILE}" ]]
    then
        #shellcheck disable=SC2155
        export FILE="$(mktemp)"
        touch "${FILE}"
    fi
    local APIURL="https://api.modrinth.com/v2/version_file/${3}/update" # Uses sha1sum of a version of ${1}
    local JQCOMMAND=".files[] | select(.filename | startswith(\"${2%'*.jar'}\"))"
    if [[ "$(mrdown "${APIURL}" | jq -r "${JQCOMMAND} | .hashes.sha1")" = "$(sha1sum "${FILE}" | head -c 40)" ]]
    then
        out "${1} is up to date!"
    else
        trash "${FILE}"
       	if curl -JLO# "$(mrdown "${APIURL}" | jq -r "${JQCOMMAND} | .url")"
        then
            out "Updated ${1}"
        else
            badfile
        fi
	popd
    fi
    intoupdate
}

pushd "${MC_DIR}" || abort '$MC_DIR does not exist or is not a directory.'
if ! wget -q --spider https://google.com/
then
    abort "No internet connection."
    exit 3
fi
##
## Update begins
##

# Purpur is not on modrinth, uses md5sum, and has custom api. Manual section.
PURPURFILE="$(find "${MC_DIR}" -maxdepth 1 -name "purpur-*.jar")"
PURPURREMOTESUM="$(curl --silent https://api.purpurmc.org/v2/purpur/1.19.4/latest | jq -r '.md5')"
PURPUROLDSUM="$(md5sum - < "${PURPURFILE}" | tr -d '  ' | tr -d  '-')"

if [[ "${PURPURREMOTESUM}" = "${PURPUROLDSUM}" ]]
then
    out "Purpur is up to date!"
else
    trash "${PURPURFILE}"
    curl -JLO# 'https://api.purpurmc.org/v2/purpur/1.19.4/latest/download'
    # Re-eval for new jar name
    PURPURFILE="$(find "${MC_DIR}" -maxdepth 1 -name "*.jar")"
    PURPUROLDSUM="$(md5sum - < "${PURPURFILE}" | tr -d '  ' | tr -d '-')"
    if [[ "${PURPUROLDSUM}" = "${PURPURREMOTESUM}" ]]
    then
        out 'Updated Purpur!'
    else
        badfile
    fi
fi
pushd "${MC_DIR}"/plugins || (abort "${MC_DIR}/plugins does not exist." && exit 1)
#shellcheck disable=SC2164
githubeval 'zeshan321/ActionHealth' 'ActionHealth-*.jar'
mreval 'Chunky' 'Chunky-*.jar' 'd57bb3ab4277aa61501aba80a2de5d111bed7f26'
mreval 'ChunkyBorder' 'ChunkyBorder-*.jar' '991471b1639beb70b006aa3b9e4d9a163428ea2e'
mreval 'CoreProtect' 'CoreProtect-*.jar' 'f36771209f036c4c1899381e16acc65cbb7a07a0'
warn 'Skipping CraftBook!' # Only available on bukkit.org (curseforge api)
consturl 'CrossPlatforms' 'https://ci.kejona.dev/job/CrossplatForms/job/main/lastSuccessfulBuild/artifact/spigot/build/libs/CrossplatForms-Spigot.jar' # Jenkins, no way to get hash
warn 'Skipping DeadChest!' # bukkit.org
mreval 'EssentialsX' 'EssentialsX-*.jar' '1142297fc1facd0f6015202b21796a99571f681d'
mreval 'EssentialsXChat' 'EssentialsXChat-*.jar' '1142297fc1facd0f6015202b21796a99571f681d'
mreval 'EssentialsXGeoIP' 'EssentialsXGeoIP-*.jar' '1142297fc1facd0f6015202b21796a99571f681d'
geysereval 'floodgate' 'floodgate-spigot.jar'
mreval 'FreedomChat' 'FreedomChat-*.jar' 'a8f48567c1ae58ae243043f2c5c914fd4dc6d76d'
geysereval 'geyser' 'Geyser-Spigot.jar'
githubeval 'Camotoy/GeyserSkinManager' 'GeyserSkinManager-Spigot*.jar'
mreval 'LibreLogin' 'LibreLogin*.jar' '00a85232e228a49b5b128729887484c1dcf28bd4'
warn 'Skipping Luckperms, and Multiverse-NetherPortals!'
githubeval 'Multiverse/Multiverse-Core' 'multiverse-core-*.jar'
githubeval 'Multiverse/Multiverse-Portals' 'multiverse-portals-*.jar'
githubeval 'Multiverse/Multiverse-Inventories' 'multiverse-inventories-*.jar'
githubeval 'Multiverse/Multiverse-SignPortals' 'multiverse-signportals-*.jar'
mreval 'Pl3x Map' 'Pl3xMap-*.jar' '3803837eede294e30c43e455166dc88aedbd0c91'
warn 'Skipping Placeholder API!'
consturl 'ProtocolLib' 'https://ci.dmulloy2.net/job/ProtocolLib/lastSuccessfulBuild/artifact/target/ProtocolLib.jar'
mreval 'Purpur Extras' 'PurpurExtras-*.jar' 'b660e25faaed4e03082c2590aa3cd77147d7fdcf'
mreval 'SchematicUpload' 'SchematicUpload-*.jar' '2727135c248e4ee5134057c65d0005a004feb4b6'
githubeval 'Dans-Plugins/SimpleSkills' 'SimpleSkills-*.jar'
mreval 'Terra' 'Terra-*.jar' '3937d24a68a5efc9acfecbe67c78d026cd7ae5a8'
githubeval 'MilkBowl/Vault'
githubeval 'ViaVersion/ViaVersion' 'ViaVersion-*.jar'
githubeval 'ViaVersion/ViaBackwards' 'ViaBackwards-*.jar'
githubeval 'MrMicky-FR/WorldEditSelectionVisualizer' 'WorldEditSelectionVisualizer-*.jar'
warn 'Skipping WorldEdit!'
mreval 'Xaero Map Spigot' 'xaero-map-*.jar' '99adb88c6749d0d7dff193bb2986c39289d5e19f'
out 'Update complete!'
popd
exit 0
