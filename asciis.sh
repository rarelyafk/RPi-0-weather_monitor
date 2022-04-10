#!/usr/bin/env bash

DG='\e[38;5;240;1m'
MG='\e[38;5;250m'
LG='\e[38;5;226m'
Y='\e[38;5;226m'
R='\e[0m'

center_txt() { printf '%*s\n' "$(( (34 + "${#1}") / 2))" "$1"; }
# remove escape characters to calculate true length of string

# 13 cols
overcast() {
  printf '%b\n' "$DG"
  printf '%s\n' "      .--.    "
  printf '%s\n' "   .-(    ).  "
  printf '%s\n' "  (___.__)__) "
  printf '%b' "$R"
}

Sunny() {
  printf '%b%s%b\n' "$Y" "  \   /   " "$R"
  printf '%b%s%b\n' "$Y" "   .-.    " "$R"
  printf '%b%s%b\n' "$Y" "― (   ) ― " "$R"
  printf '%b%s%b\n' "$Y" "   \`-’   " "$R"
  printf '%b%s%b\n' "$Y" "  /   \   " "$R"
}

partly_cloudy() {
  printf '%b%s%b\n'     "$Y" "   \  /                    "  "$R"
  printf '%b%s%b%s%b\n' "$Y" " _ /\"\"" "$MG"  ".-.      "  "$R"
  printf '%b%s%b%s%b\n' "$Y" "   \_"    "$MG" "(   ).    "  "$R"
  printf '%b%s%b%s%b\n' "$Y" "   /"     "$MG" "(___(__)   " "$R"
}

"$1"
# overcast
#partly_cloudy
