#! /bin/bash
# ran on db server
export COLUMNS=100

while true; do
  # cpu, mem
  top -c -b -d 1 -n 1 | grep "[p]ostgres: admin" | awk -F' ' 'BEGIN{cpu_sum=0; mem_sum=0}{cpu_sum=cpu_sum+$9; mem_sum=mem_sum+$10}END{print "cpu(%): "cpu_sum"\nmem(%): "mem_sum}'

  echo ""
  sleep 1
done
