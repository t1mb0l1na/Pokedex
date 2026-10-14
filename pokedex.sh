#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="$SCRIPT_DIR/data/pokemon.csv"
REGIONS="$SCRIPT_DIR/data/regions.csv"


print_entry() {
  # takes one CSV row, parses the 7 fields, pretty-prints them
IFS=, read -r num name type1 type2 height weight desc <<< "$1"
desc="${desc#\"}"; desc="${desc%\"}"; desc="${desc//\"\"/\"}"
name="${name^}"; type1="${type1^}"; type2="${type2^}"

if [ -z "$type2" ]; then
    types="$type1"
else
    types="$type1/$type2"
fi

printf '#%s %s\n' "$num" "$name"
printf 'Type: %s\n' "$types"
printf 'Height: %s m | Weight: %s kg\n' "$height" "$weight"
printf '"%s"\n' "$desc"


}

query=$(echo "$1" | tr '[:upper:]' '[:lower:]')

case "$query" in
  kanto|johto|...)
    # region branch → range lookup → print compact list

	read start end <<< "$(awk -F, -v q="$query" '$1==q {print $2, $3}' "$REGIONS")"
	awk -F, -v lo="$start" -v hi="$end" 'NR>1 && $1>=lo && $1<=hi {print $1, $2}' "$DATA"

    ;;
  ''|*[!0-9]*)
    # name branch → awk finds row → print_entry
row=$(awk -F, -v q="$query" 'NR>1 && $2==q' "$DATA")
if [ -z "$row" ]; then
        echo "No Pokémon found for '$1' — check your spelling."
    else
        print_entry "$row"
    fi
    ;;
  *)
    # number branch → awk finds row → print_entry
row=$(awk -F, -v q="$query" 'NR>1 && $1==q' "$DATA")

if [ -z "$row" ]; then
        echo "No Pokémon found for '$1' — check your numbers."
    else
        print_entry "$row"
    fi
    ;;

esac
