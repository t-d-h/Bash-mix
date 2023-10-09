#!/bin/bash
for i in $(ls /storage/backups/docker-compose-node/ -I "*.tar.gz")
do
    echo "compressing: " $i
    cd /storage/backups/docker-compose-node/ && tar -czf $i-$(date +%d-%b-%Y).tar.gz $i
    echo "output: " /storage/backups/docker-compose-node/$i-$(date +%d-%b-%Y).tar.gz
    rm -rf /storage/backups/docker-compose-node/$i
    echo "==============="
done