#!/usr/bin/env bash
set -euo pipefail
usage(){
  echo "usage: ${0} integer integer integer ..."
}
case "${#}" in
'0'|'1')
  usage
  exit 2
  ;;
"*")
  :
  ;;
esac
SUM='0'
for x in ${@}
do
  SUM="$(expr "$SUM" + "$x")"
done
echo "$SUM / $#" > /tmp/average.txt
printf "%s\n" "$(bc /tmp/average.txt)"
exit 0
