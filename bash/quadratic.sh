#!/usr/bin/env bash
set -e
set -x
### Options
# Configurable variables
MAX_SEARCH_PRIME_POWER=8
DEBUG=false

### Vars and Functions
# Internal variables
IMAGINARY=false
# Error function
error(){
  printf '%s\n' "ERROR: ${1}"
  exit "${2}"
}
debug(){
 [[ "${DEBUG}" == true ]] && printf '%s\n' "DEBUG: ${*}"
}

### Preliminary Checks
# Test for 3 args

if [[ "${#}" -ne 3 ]]
then
  error 'Must have 3 arguments' 2
fi
# Var setting
A="${1}" && B="${2}" && C="${3}"
# Check that args are numbers
for INT in "${A}" "${B}" "${C}"
do
  if ! [ "${INT}" -eq "${INT}" ] # Would use [[]]; but [[ a -eq a ]] returns 0 (even though it's a letter!? ) whereas [ a -eq a ] returns 2 (thankfully).
  then
    error 'Arguments must be numbers' 3
  fi
done
# Ensure presence of `factor` and `bc`
if ! which factor &>/dev/null
then
  #shellcheck disable=SC2016
  error '`factor` is not your PATH' 4
fi
if ! which bc &>/dev/null
then
  #shellcheck disable=SC2016
  error '`bc` is not your PATH' 4
fi

### Discriminant
DISCRIMINANT="$(bc <<< "${B}*${B} - 4*${A}*${C}")"
if [[ "${DISCRIMINANT}" -le 0 ]]
then
  IMAGINARY=true
fi
debug "Discriminant: ${DISCRIMINANT}"
debug "Imaginary roots: ${IMAGINARY}"
