#!/usr/bin/env bash

### time should update independently every min
# date="$(date +'%m-%d')"
# time="$(date +'%H:%M')"

# line wrap off
printf '\e[?7l'
# hide cursor
printf '\e[?25l'

# colors
RED='\e[31m'
GRN='\e[32m'
YEL='\e[33m'
BLU='\e[34m'
WHT='\e[37m'
RST='\e[0m'

###############################################################################
# infinite loop shorthand
while :; do

  date="$(date +'%m-%d')"
  time="$(date +'%H:%M')"

  LIST="$(curl -s 'https://wttr.in/CHS?format=%C|%t|%f|%w|%p|%D|%d')"
  sani="$(echo "${LIST}" | sed -e 's/ /_/g')"
  sani="${sani//|/ }"
  declare -a vals=($sani) 

  declare -A MAP=(\
    ['desc']="${vals[0],,}"\
    ['temp']="${vals[1]:1:2}"\
    ['feel']="${vals[2]:1:2}"\
    ['wind']="${vals[3]:1:-3}"\
    ['rain']="${vals[4]:0:-2}"\
    ['dawn']="${vals[5]:0:5}"\
    ['dusk']="${vals[6]:0:5}"\
  )


  # transforms

  # temp
  [[ "${MAP['temp']}" = "${MAP['feel']}" ]]\
    && unset MAP['temp']

  # rain
  [[ "${MAP['rain']}" = "0.0" ]]\
    && { unset MAP['rain']; }\
    || { MAP['rain']="${MAP['rain']}mm/3hrs"; }


  # color transforms

  center_txt() {
    local -r orig_len="${#1}"
    local -r chars="$(echo "$1" | sed 's/\x1B\[[0-9;]*m//g')"
    local -r len="${#chars}"
    local -r diff="$(( $orig_len - $len ))"
    local -r center="$(( ( (34 + "$len") / 2 ) + "$diff" ))"
    printf '%*s\n' "$center" "$1"
  }
  setFG() { printf '%b%s%b' "$2" "$1" "$RST"; }

  # feel
  if [[ "${MAP['feel']}" -ge 70 ]] && [[ "${MAP['feel']}" -le 80 ]]; then
    MAP['feel']="$(setFG "${MAP['feel']}" "$GRN")"
  elif [[ "${MAP['feel']}" -gt 80 ]]; then
    MAP['feel']="$(setFG "${MAP['feel']}" "$RED")"
  else
    MAP['feel']="$(setFG "${MAP['feel']}" "$BLU")"
  fi

  # wind
  if [[ "${MAP['wind']}" -le 5 ]]; then
    unset MAP['wind']
  elif [[ "${MAP['wind']}" -gt 15 ]]; then
    MAP['wind']="$(setFG "${MAP['wind']}" "$RED")"
  else
    MAP['wind']="$(setFG "${MAP['wind']}" "$YEL")"
  fi

  # rain
  if [[ "${MAP['rain']}" < 0.66 ]]; then
    MAP['rain']="$(setFG "${MAP['rain']}" "$GRN")"
  elif [[ "${MAP['rain']}" > 0.66 ]] && [[ "${MAP['rain']}" < 1.33 ]]; then
    MAP['rain']="$(setFG "${MAP['rain']}" "$BLU")"
  elif [[ "${MAP['rain']}" > 1.33 ]] && [[ "${MAP['rain']}" < 2.66 ]]; then
    MAP['rain']="$(setFG "${MAP['rain']}" "$YEL")"
  else
    MAP['rain']="$(setFG "${MAP['rain']}" "$RED")"
  fi


# #  ## 11 LINES 34 COLUMNS to work with
  # echo '1234567890123456789012345678901234'
  clear

  # date/time
  center_txt "$date"
  center_txt "[ ${time} ]"

  # ascii's
  center_txt "${MAP['desc']}"
  [[ "$time" > "${MAP['dawn']}" ]] && [[ "$time" < "${MAP['dusk']}" ]] &&\
    bash "${PWD}/asciis.sh" "${MAP['desc']}"

  echo

  # use column or pr to evenly space fields?
  printf '%s\t%s\n' "${MAP['temp']}" "${MAP['wind']}"
  [[ -v "${MAP['rain']}" ]] && printf '%s\n' "${MAP['rain']}"
  printf '%b%s%b' "$(center_txt "${MAP['feel']}")"

  sleep 360
done
###############################################################################

cleanup() {
  unset LIST vals key val
  # unset condition keys
  for((;i++<4;)){ unset "${keys[$i]}";}
  # show cursor
  printf '\e[?25h'
  # re-enable linewrapping
  printf '\e[?7h'
}
trap 'cleanup' SIGINT EXIT

###############################################################################

# evtest for touchscreen events

  # declare -A COND
  #   ['temp']=''\
  #   ['feel']=''\
  #   ['wind']=''\
  #   ['rain']=''\
  #   ['dawn']=''\
  #   ['dusk']=''\
  # )

  # for i in {0..6}; do
    # echo "key: ${keys[$i]} val: ${vals[$i]}"

  # [[ ! -v keys ]] &&\
  #   declare -r -a keys=('desc' 'temp' 'feel' 'wind' 'rain' 'dawn' 'dusk')

  # for key in "${!MAP[@]}"; do
  #   val="${MAP["$key"]}"
  #   echo "key: $key    val: $val"
  #   # case "$key" in
  #   #   dawn|dusk) MAP[$key]="${MAP[$key]:0:5}";;
  #   #   feel|temp|wind) declare "$key"=" ${val:1:2}";; # feel/temp/wind to numbers only
  #   #   *) declare "$key"="$val";;
  #   # esac
  # done
  # unset key val

# declare -r DIR="$(dirname ${BASH_SOURCE[0]})"
# echo "{BASH_SOURCE[0]}"
# echo "$PWD"
# echo "${DIR}/asciis.sh"

  # center_txt() {
  #   local -r chars="$(echo "$1" | sed 's/\x1B\[[0-9;]*m//g')"
  #   local -r len="${#chars}"
  #   printf '%*s\n' "$(( (34 + "${len}") / 2))" "$1"
  # }
