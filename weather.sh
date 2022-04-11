#!/usr/bin/env bash

dir="$(dirname ${BASH_SOURCE[0]})"

# line wrap off
printf '\e[?7l'
# hide cursor
printf '\e[?25l'

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


  [[ "$temp" = "$feel" ]] && temp='' || temp="${temp:1}"
  [[ "$rain" = "0.0mm" ]] && rain='' || rain="${rain}/3hrs"

  # if [[ "$feel" -ge 70 ]] && [[ "$feel" -le 80 ]]; then
  # elif [[ "$feel" -gt 80 ]]; then
  # elif [[ "$feel" -lt 70 ]]; then
  # fi
  # if [[ "$wind" -le 5 ]]; then
  # elif [[ "$wind" -gt 5 ]]; then
  # elif [[ "$wind" -gt 10 ]]; then
  # elif [[ "$wind" -gt 15 ]]; then
  # elif [[ "$wind" -gt 20 ]]; then
  # fi

  date="$(date +'%m-%d')"
  # time should update independently every min
  time="$(date +'%H:%M')"

  clear
#  ## 11 LINES 34 COLUMNS to work with
  center_txt "$date"
  center_txt "[ ${time} ]"
  echo '1234567890123456789012345678901234'
  [[ -z "$temp" ]] && temp_name='' || temp_name='temp'
  printf '%s\t\t%s\t%s\n' "feel" "$temp_name" " wind"
  printf '%s\t\t%s\t%s\n' "$feel" "$temp" "$wind"
  # center_txt "$desc"
  "${dir}/asciis.sh" "$desc"
  #figlet "$feel"

  sleep 360
done

# cleanup trap
cleanup() {
  unset LIST vals key val
  for((;i++<9;)){ unset "${keys[$i]}";}
}
trap 'cleanup' SIGINT EXIT

# evtest for touchscreen events
    # declare -r -a keys=('icon' 'desc' 'hmdt' 'temp' 'feel' 'wind' 'rain' 'dawn' 'dusk' 'time')
  # LIST="$(curl -s 'https://wttr.in/CHS?format=%c|%C|%h|%t|%f|%w|%p|%S|%s|%T')"
      # dawn|dusk|time) declare "$key"="${val:0:5}";; # truncate times to HH:mm
      # time) declare "$key"="${val:0:5}";; # truncate time to HH:mm
