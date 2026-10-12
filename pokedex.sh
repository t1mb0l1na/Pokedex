#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="$SCRIPT_DIR/data/pokemon.csv"
REGIONS="$SCRIPT_DIR/data/regions.csv"


print_entry() {
  # takes one CSV row, parses the 7 fields, pretty-prints them
	:
}

query=$(echo "$1" | tr '[:upper:]' '[:lower:]')

case "$query" in
  kanto|johto|...)
    # region branch → range lookup → print compact list

	read start end <<< "$(awk -F, -v q="$query" '$1==q {prit $2, $3}' "REGIONS")"
	awk -F, -v lo="$start" -v hi="$end" 'NR>1 && $1>=lo && $1<=hi {print $1, $2}' "DATA"
	
    ;;
  ''|*[!0-9]*)
    # name branch → awk finds row → print_entry
row=$(awk -F, -v q="$query" 'NR>1 && $2==q' "$DATA")

echo  "$row"
    ;;
  *)
    # number branch → awk finds row → print_entry
row=$(awk -F, -v q="$query" 'NR>1 && $1==q' "$DATA")

echo  "$row"
    ;;
esac
