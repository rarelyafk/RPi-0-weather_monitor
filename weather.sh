#!/usr/bin/env bash

dir="$(dirname ${BASH_SOURCE[0]})"

# line wrap off
printf '\e[?7l'
# hide cursor
printf '\e[?25l'

# colors
yel='\e[33m'
red='\e[31m'
blu='\e[34m'
grn='\e[32m'
R='\e[0m'

center_txt() { printf '%*s\n' "$(( (34 + "${#1}") / 2))" "$1"; }

# infinite loop shorthand
while :; do

  [[ ! -v keys ]] &&\
    declare -r -a keys=('desc' 'temp' 'feel' 'wind' 'rain')
  LIST="$(curl -s 'https://wttr.in/CHS?format=%C|%t|%f|%w|%p')"
  read -r -a vals <<< "${LIST//'|'/' '}"
  for i in {0..9}; do
    declare key="${keys[$i]}" val="${vals[$i]}"
    case "$key" in
      feel|temp|wind) declare "$key"=" ${val:1:2}";; # feel/temp/wind to numbers only
      *) declare "$key"="$val";;
    esac
  done
  unset vals key val

  feelN='feel'
  tempN='temp'
  windN='wind'
  rainN='rain'
  [[ "$temp" = "$feel" ]] && { temp=''; tempN=''; } || temp="${temp:1}"
  [[ "$rain" = "0.0mm" ]] && { rain=''; rainN=''; } || rain="${rain}/3hrs"

  if [[ "$feel" -ge 70 ]] && [[ "$feel" -le 80 ]]; then
    feel="$(printf '%b%s%b' "$grn" "$feel" "$R")"
  elif [[ "$feel" -gt 80 ]]; then
    feel="$(printf '%b%s%b' "$red" "$feel" "$R")"
  elif [[ "$feel" -lt 70 ]]; then
    feel="$(printf '%b%s%b' "$blu" "$feel" "$R")"
  fi
  if [[ "$wind" -le 5 ]]; then
    wind=''
    windN=''
  elif [[ "$wind" -gt 15 ]]; then
    wind="$(printf '%b%s%b' "$red" "$wind" "$R")"
  elif [[ "$wind" -gt 10 ]]; then
    wind="$(printf '%b%s%b' "$yel" "$wind" "$R")"
  fi

  date="$(date +'%m-%d')"
  # time should update independently every min
  time="$(date +'%H:%M')"

  clear
#  ## 11 LINES 34 COLUMNS to work with
  # echo '1234567890123456789012345678901234'
  center_txt "$date"
  center_txt "[ ${time} ]"
  # use column or pr to evenly space fields?
  printf '%s\t%s\t%s\t%s\n' "$feelN" "$tempN" " $windN" "$rainN"
  printf '%s\t%s\t%s\t%s\n' "$feel" "$temp" "$wind" "$rain"
  bash "${dir}/asciis.sh" "$desc"

  sleep 360
done

cleanup() {
  unset LIST vals key val
  for((;i++<9;)){ unset "${keys[$i]}";}
}
trap 'cleanup' SIGINT EXIT

# evtest for touchscreen events
