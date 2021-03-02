#! /bin/bash
cd $1

grep "tps = " *.txt | awk -F' ' 'BEGIN{sum=0}{sum=sum+$3}END{print "tps: "sum/2}'
grep "latency average = " *.txt | awk -v fnox=$(ls -l *.txt | wc -l) -F' ' 'BEGIN{sum=0}{sum=sum+$4}END{print "lat: "sum/fnox}'
