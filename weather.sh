#!/usr/bin/env bash

# infinite loop shorthand
while :; do

  [[ ! -v keys ]] &&\
    declare -r -a keys=('icon' 'desc' 'hmdt' 'temp' 'feel' 'wind' 'rain' 'dawn' 'dusk' 'time')

  LIST="$(curl -s 'https://wttr.in/CHS?format=%c|%C|%h|%t|%f|%w|%p|%S|%s|%T')"
  read -r -a vals <<< "${LIST//'|'/' '}"

  for i in {0..9}; do
    declare key="${keys[$i]}" val="${vals[$i]}"
    case "$key" in
      dawn|dusk|time) declare "$key"="${val:0:5}";; # truncate times to HH:mm
      feel|wind) declare "$key"="${val:0}";;
      temp) declare "$key"="${val:1:2}";;
      *) declare "$key"="$val";;
    esac
  done
  unset vals key val
  
  # sleep interval & clear before printing
  sleep 10
  clear

#  ## 11 LINES 34 COLUMNS to work with
#  #icon desc hmdt temp feel wind rain dawn dusk time
  center_txt() { printf '%*s\n' "$(( (34 + "${#1}") / 2))" "$1"; }

  [[ "$temp" = "$feel" ]] && temp='' || temp="${temp:1}"
  [[ "$rain" = "0.0mm" ]] && rain='' || rain="${rain}/3hrs"

  center_txt "[ ${time} ]"
  echo '1234567890123456789012345678901234'
  printf '%s\t\t%s\t%s\n' "feel" "temp" "wind"
  printf '%s\t\t%s\t%s\n' "$feel" "$temp" "$wind"
  center_txt "$desc"
  ./asciis.sh "$desc"
  #figlet "$feel"
done

# cleanup trap
cleanup() {
  unset LIST vals key val
  for((;i++<9;)){ unset "${keys[$i]}";}
}
trap 'cleanup' SIGINT EXIT

# evtest for touchscreen events
