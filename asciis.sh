#!/usr/bin/env bash

DG='\e[38;5;240;1m'
MG='\e[38;5;250m'
LG='\e[38;5;226m'
Y='\e[38;5;226m'
R='\e[0m'

# 13 cols
overcast() {
  printf '%b' "$DG"
  printf '%s\n' "      .--.    "
  printf '%s\n' "   .-(    ).  "
  printf '%s\n' "  (___.__)__) "
  printf '%b' "$R"
}

sunny() {
  printf '%b' "$Y"
  printf '%s\n' "   \   /      "
  printf '%s\n' "    .-.       "
  printf '%s\n' " ― (   ) ―    "
  printf '%s\n' "    \`-’     "
  printf '%s\n' "   /   \      "
  printf '%b' "$R"
}

partly_cloudy() {
  printf '%b%s%b\n'     "$Y" "   \  /" "$R"
  printf '%b%s%b%s%b\n' "$Y" " _ /\"\"" "$MG" ".-.    " "$R"
  printf '%b%s%b%s%b\n' "$Y" "   \_" "$MG" "(   ).  " "$R"
  printf '%b%s%b%s%b\n' "$Y" "   /" "$MG" "(___(__) " "$R"
}

sunny
# overcast
#partly_cloudy
