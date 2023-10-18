#!/bin/bash

domain=serveur.win
ip=$(host $domain | awk '{print $NF}')

if cat /etc/csf/csf.allow | grep "$ip"; then
  echo "$ip is currently allowed, no need to change"
  exit
fi

echo "$ip is not allowed, need to change"
echo "$ip" >> /etc/csf/csf.allow
csf -r