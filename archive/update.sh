#!/usr/bin/env bash
MC_DIR='~/Minecraft'
PURPUR='true'
VELOCITY='true'
GEYSER='true'
FLOODGATE='true'
neveruse(){
  echo "Updating \"${1}\" . . . "
  while [[ "$#" -ne '0' ]]
  do
    case "$1" in
    -p)
      DIR="$1"
      shift
      continue
      ;;
    *)
      if [[ -z "$DIR" ]]
      then
        DIR='.'
      fi
      mv -f ./"$DIR"/"$1".jar ./.old-jars/"$1".jar
      ;;
    esac
  done
  trap "echo 'Interrupt' && mv ./.old-jars/old-${1}.jar ./${DIR}/${1}.jar" 1 2 3 6
}
fini(){
  trap -
}
cd "$MC_DIR"
if [[ "$PURPUR" = 'true' ]]
then
  echo 'Updating Purpur ...'
  mv -f ./purpur-1.??.?-????.jar ./.old-jars/old-purpur.jar
  trap 'echo "Interrupt" && mv ./.old-jars/old-purpur.jar ./purpur.jar' 1 2 3 6
  curl -JLO# https://api.pl3x.net/v2/purpur/1.18.2/latest/download
  fini
fi
if [[ "$VELOCITY" = 'true' ]]
then
  'velocity'
  curl -# https://chew.pw/mc/jars/velocity -o ./velocity.jar
  fini
fi
if [[ "$GEYSER" = 'true' ]]
then
  e -p 'plugins' 'geyser'

  curl -JLO# https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar
  curl -JLO# https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/velocity/target/Geyser-Velocity.jar
  fini
fi
if [[ "$FLOODGATE" = 'true' ]]
then
  e -p 'plugins' 'floodgate'
  curl -JLO# https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/ -o ./plugins/Floodgate.jar
