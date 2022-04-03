#!/usr/bin/env bash

# infinite loop shorthand
while :; do
  # get weather condition ascii art & weather condition metrics
  ASCII="$(curl -s 'https://wttr.in/CHS?0' |\
    awk '(NR > 2) {sub(/\[0m.*$/,"[0m"); print}')"
  LIST="$(curl -s 'https://wttr.in/CHS?format=%c|%C|%h|%t|%f|%w|%p|%S|%s|%T')"

  [[ ! -v keys ]] &&\
    declare -r -a keys=(icon desc hmdt temp feel wind rain dawn dusk time)
  read -r -a vals <<< "${LIST//'|'/' '}"
  for i in {0..9}; do
    declare key="${keys[$i]}" val="${vals[$i]}"
    case "$key" in
      dawn|dusk|time) declare "$key"="${val:0:5}";; # truncate times to HH:mm
      *) declare "$key"="$val";;
    esac
  done
  unset vals key val
  
  # sleep interval & clear before printing
  sleep 60
  clear

  ## 11 LINES 34 COLUMNS to work with
  #icon desc hmdt temp feel wind rain dawn dusk time
  [[ "$temp" = "$feel" ]] && temp='' || temp="(${temp})"
  [[ "$rain" = "0.0mm" ]] && rain=''
  echo "$ASCII"
  printf '[ %s ] %s %s %s %s\n' "$time" "$desc" "$icon" "$feel" "$temp"
  printf '%s %s %s\n' "$rain" "$hmdt" "$wind"
  printf 'dawn: %s\tdusk: %s\n' "$dawn" "$dusk"
done

# cleanup trap
cleanup() {
  unset LIST vals key val
  for((;i++<9;)){ unset "${keys[$i]}";}
}
trap 'cleanup' SIGINT EXIT

#
# [[ -f tmp.json ]] && rm tmp.json
  # curl -s 'https://wttr.in/CHS?format=%c'
##curl -s 'wttr.in/CHS?0' | awk '(NR > 2) {print substr($0,0,30)}'
# declare -A COND
    # dawn|dusk|time) COND["$key"]="${val:0:5}";;
  # declare key="${keys[$i]}" val="${vals[$i]}"
  # case "$key" in
  #   dawn|dusk|time) COND["$key"]="${val:0:5}";;
  #   *) COND["$key"]="$val";;
  # esac
# for key in "${!COND[@]}"; do
#   echo "$key - ${COND[$key]}"
# done
#  # curl -s 'https://wttr.in/CHS?format=j1' > tmp.json
#  DESC="$(jq -r '.current_condition[0].weatherDesc[0].value' tmp.json)"
#  TEMP="$(jq -r '.current_condition[0].temp_F' tmp.json)"
#  FEEL="$(jq -r '.current_condition[0].FeelsLikeF' tmp.json)"
#  RAIN="$(jq -r '.current_condition[0].precipInches' tmp.json)"
#  WIND="$(jq -r '.current_condition[0].windspeedMiles' tmp.json)"
#  DAWN="$(jq -r '.weather[0].astronomy[0].sunrise' tmp.json)"
#  DUSK="$(jq -r '.weather[0].astronomy[0].sunset' tmp.json)"
#  AVGT="$(jq -r '.weather[0].avgtempF' tmp.json)"
#  MINT="$(jq -r '.weather[0].mintempF' tmp.json)"
#  MAXT="$(jq -r '.weather[0].maxtempF' tmp.json)"
#
#  echo "$DESC $FEEL°F ($TEMP°F)"
#  echo "($AVGT°F ($MINT°F - $MAXT°F))"
#  echo "sun: $DAWN - $DUSK"
#  sleep 9000
