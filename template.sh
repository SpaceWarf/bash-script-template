#!/bin/bash
set -e

USAGE="
usage: template [POS] [-m MULTIPLE] [-s SINGLE]
	A template bash script with complete positional parameter and options handling.

positional arguments:
	POS                   A positional argument. Default: pos

optional arguments:
	-m, --multiple        An option which can be used multiple times in the command.
	-s, --single          An option which can be used a single time in the command.
"

PARAMS=""
DEFAULT_POS="pos"

# Evaluate command flags
while (( "$#" )); do
  case "$1" in
	-h|--help)
	  echo "$USAGE"
	  exit 0
	  ;;
	-m|--multiple)
	  if [ -z $2 ]
		then
		  shift
	  else
		MULTIPLE+=("$2")
		shift 2
	  fi
	  ;;
	-s|--single)
	  if [ -z $2 ]
		then
		  shift
	  else
		SINGLE=$2
		shift 2
	  fi
	  ;;
	--) # end argument parsing
	  shift
	  break
	  ;;
	-*|--*=) # unsupported flags
	  echo "Unsupported flag $1" >&2
	  exit 1
	  ;;
	*) # preserve positional arguments
	  PARAMS="$PARAMS $1"
	  shift
	  ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"
POS=$1

if [ -z $POS ]
  	then
		echo "No positional argument detected. Using default: $DEFAULT_POS"
		POS=$DEFAULT_POS
fi

if [[ -z $SINGLE ]]
  	then
		echo "No single flag specified."
fi

if [[ -z $MULTIPLE ]]
	then
		echo "No multiple flag specified."
fi

echo
echo "--- running script with parameters ---"
echo "POS: $POS"
echo "SINGLE: $SINGLE"
echo "MULTIPLE: $(printf '%s, ' "${MULTIPLE[@]}")"
