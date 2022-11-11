#!/bin/bash
#current_time=$(ssh parksejin@15.40.187.106 "date '+%Y-%m-%d %H:%M:%S'")
#current_time=$(ssh parksejin@175.118.12.219 "date '+%Y-%m-%d %H:%M:%S'")

ips=("15.26.228.11" "www.dhqhrtnwl.shop")
skip_ping=false

function get_rtc
{
  ip="${1}"

  if [ $skip_ping == false ]; then
    echo "ping -c 1 $ip"
    ping -c 1 "${ip}"
    if [ "$?" != "0" ]; then
      return
    fi
  fi

  set -x
  current_time=$(ssh parksejin@${ip} "date '+%Y-%m-%d %H:%M:%S'")
  timedatectl set-time "$current_time"
  set +x
  echo "RTC setting completed"
  exit 0
}

function print_usage
{
  echo "(Usage) ${0} [IP] [-no_ping]"
  echo "(Example) ${0}"
  echo "(Example) ${0} www.dhqhrtnwl.shop"
  echo "(Example) ${0} www.dhqhrtnwl.shop -no_ping"
}

for i in "$@"
do
case $i in
  -no_ping)
    skip_ping=true
    echo "No Ping Mode"
    ;; 
  -h)
    print_usage
    exit 0
    ;;
esac
done

if [ "${1}" != "" ]; then
  ip="${1}"
  echo "Checking IP ${ip}"
  get_rtc "${ip}"
  exit 0
fi

for ip in ${ips[@]}
do
  echo "Checking IP ${ip}"
  get_rtc "${ip}"
done
