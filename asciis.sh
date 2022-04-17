#!/usr/bin/env bash

DG='\e[38;5;240;1m'
MG='\e[38;5;250m'
LG='\e[38;5;226m'
Y='\e[38;5;226m'
R='\e[0m'

declare -r -A CONDITIONS=(\
  ['sunny']='sun'\
  ['clear']='sun'\
  ['overcast']='overcast'\
  ['partly_cloudy']='partly_cloudy'\
  ['light_rain']='partly_cloudy'\
)
#ascii for light_rain???

# center_txt() { printf '%*s\n' "$(( (34 + "${#1}") / 2))" "$1"; }
center_txt() {
  local -r orig_len="${#1}"
  local -r chars="$(echo "$1" | sed 's/\x1B\[[0-9;]*m//g')"
  local -r len="${#chars}"
  local -r diff="$(( $orig_len - $len ))"
  local -r center="$(( ( (34 + "$len") / 2 ) + "$diff" ))"
  printf '%*s\n' "$center" "$1"
}
# remove escape characters to calculate true length of string

# echo '1234567890123456789012345678901234'
# 34 cols wide
# 17 is halfway

# 13 cols?
sun() {
  # echo '1234567890123456789012345678901234'
  center_txt "$(printf '%b%s%b\n' "$Y" "   \   /   " "$R")"
  center_txt "$(printf '%b%s%b\n' "$Y" "    .-.    " "$R")"
  center_txt "$(printf '%b%s%b\n' "$Y" "        ― (   ) ― " "$R")"
  center_txt "$(printf '%b%s%b\n' "$Y" "       \`-’   " "$R")"
  center_txt "$(printf '%b%s%b\n' "$Y" "   /   \   " "$R")"
  # echo '1234567890123456789012345678901234'
}

overcast() {
  # echo '1234567890123456789012345678901234'
  printf '%b' "$DG"
  center_txt "$(printf '%s\n' "    .--.   ")"
  center_txt "$(printf '%s\n' " .-(    ). ")"
  center_txt "$(printf '%s\n' "(___.__)__)")"
  printf '%b' "$R"
  # echo '1234567890123456789012345678901234'
}

partly_cloudy() {
  # echo '1234567890123456789012345678901234'
  center_txt "$(printf '%b%s%b\n'     "$Y" "   \  /      "  "$R")"
  center_txt "$(printf '%b%s%b%s%b\n' "$Y" " _ /\"\"" "$MG"  ".-.    "  "$R")"
  center_txt "$(printf '%b%s%b%s%b\n' "$Y" "   \_"    "$MG" "(   ).  "  "$R")"
  center_txt "$(printf '%b%s%b%s%b\n' "$Y" "   /"     "$MG" "(___(__)" "$R")"
  # echo '1234567890123456789012345678901234'
}

# lookup condition in CONDITIONS associative array and run function associated
"${CONDITIONS["${1}"]}"
