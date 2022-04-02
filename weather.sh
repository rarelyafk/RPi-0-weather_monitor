#!/usr/bin/env bash

[[ -f tmp.json ]] && rm tmp.json

# infinite loop shorthand
while :; do
  clear
  curl -s 'https://wttr.in/CHS?0' | awk '(NR > 2) {sub(/\[0m.*$/,"[0m"); print}'

  curl -s 'https://wttr.in/CHS?format=j1' > tmp.json

  DESC="$(jq -r '.current_condition[0].weatherDesc[0].value' tmp.json)"
  TEMP="$(jq -r '.current_condition[0].temp_F' tmp.json)"
  FEEL="$(jq -r '.current_condition[0].FeelsLikeF' tmp.json)"
  RAIN="$(jq -r '.current_condition[0].precipInches' tmp.json)"
  WIND="$(jq -r '.current_condition[0].windspeedMiles' tmp.json)"
  DAWN="$(jq -r '.weather[0].astronomy[0].sunrise' tmp.json)"
  DUSK="$(jq -r '.weather[0].astronomy[0].sunset' tmp.json)"
  AVGT="$(jq -r '.weather[0].avgtempF' tmp.json)"
  MINT="$(jq -r '.weather[0].mintempF' tmp.json)"
  MAXT="$(jq -r '.weather[0].maxtempF' tmp.json)"

  echo "$DESC $FEEL°F ($TEMP°F)"
  echo "($AVGT°F ($MINT°F - $MAXT°F))"
  echo "sun: $DAWN - $DUSK"
  sleep 9000
done

# cleanup trap
cleanup() { unset DESC TEMP FEEL RAIN WIND DAWN DUSK AVGT MINT MAXT; rm tmp.json; }
trap 'cleanup' SIGINT EXIT

#curl -s 'wttr.in/CHS?0' | awk '(NR > 2) {print substr($0,0,30)}'
