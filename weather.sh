#!/usr/bin/env bash

[[ -f tmp.json ]] && rm tmp.json

curl -s 'https://wttr.in/CHS?0' | awk '(NR > 2) {sub(/\[0m.*$/,"[0m"); print}'

curl -s 'https://wttr.in/CHS?format=j1' > tmp.json
declare -r DESC="$(jq -r '.current_condition[0].weatherDesc[0].value' tmp.json)"
declare -r TEMP="$(jq -r '.current_condition[0].temp_F' tmp.json)"
declare -r FEEL="$(jq -r '.current_condition[0].FeelsLikeF' tmp.json)"
declare -r RAIN="$(jq -r '.current_condition[0].precipInches' tmp.json)"
declare -r WIND="$(jq -r '.current_condition[0].windspeedMiles' tmp.json)"
declare -r DAWN="$(jq -r '.weather[0].astronomy[0].sunrise' tmp.json)"
declare -r DUSK="$(jq -r '.weather[0].astronomy[0].sunset' tmp.json)"
declare -r AVGT="$(jq -r '.weather[0].avgtempF' tmp.json)"
declare -r MINT="$(jq -r '.weather[0].mintempF' tmp.json)"
declare -r MAXT="$(jq -r '.weather[0].maxtempF' tmp.json)"
echo "$DESC $FEEL°F ($TEMP°F)"
echo
echo "($AVGT°F ($MINT°F - $MAXT°F))"
echo
echo "sun: $DAWN - $DUSK"

cleanup() { rm tmp.json; }

trap 'cleanup' SIGINT EXIT

#curl -s 'wttr.in/CHS?0' | awk '(NR > 2) {print substr($0,0,30)}'
