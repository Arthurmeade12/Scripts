#!/bin/bash
set -xeuo pipefail
VERSION=10.14
STATUS=enabled
case "$VERSION" in
11.*|12.*)
  echo "ERROR: I'm sorry, but this script will not work on your system due to changes implemented in Big Sur. "
  ;;
10.15.*|10.14.*|10.13.*|10.12.*|10.11.*)
  case "$STATUS" in
  enabled.)
    echo 'ERROR: SIP is enabled. This script needs SIP to be disabled so that it can touch the System folder. '
    echo 'To disable SIP, follow the steps on this link: https://www.imore.com/how-turn-system-integrity-protection-macos'
    exit 1
    ;;
  disabled.)
    echo 'Detected SIP to be disabled. Proceeding. '
    ;;
  esac
  ;;
10.10|10.[98])
  # SIP does not exist on these versions, no changes necesarry.
  echo 'SIP is non-existent'
  ;;
esac
