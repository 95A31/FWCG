#!/bin/bash

glpsol --cuts --fpump --math worldcup2014.mod --output solution.txt

echo "GROUP,TEAM1,TEAM2,DATE,STADIUM" > calend2014.csv

cat solution.txt | \
  sed ':a;N;$!ba;s/]\n/]/g' | \
  grep "matches\[" | \
  grep -v "0             0" | \
  cut -f2 -d"[" | cut -f1 -d"]" \
  >> calend2014.csv