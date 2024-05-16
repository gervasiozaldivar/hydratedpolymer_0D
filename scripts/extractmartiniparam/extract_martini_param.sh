#!/bin/bash

beads=("W" "P4" "N4" "C5" "C4" "C3" "C2" "C1" "X2" "Q5" "Q4" "Q3" "Q2" "Q1")

beadnumber=${#beads[@]}

total=0

for ((i = 1; i <= beadnumber; i++)); do
  total=$((total + i))
done
  total=$((total*3))

count=0

grep " ${beads[0]}     ${beads[0]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[0]}\_${beads[0]}.dat
grep "S${beads[0]}    S${beads[0]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[0]}\_${beads[0]}.dat
grep "T${beads[0]}    T${beads[0]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[0]}\_${beads[0]}.dat


for ((i = 0; i < ${#beads[@]}; i++)); do
    for ((j = i ; j < ${#beads[@]}; j++)); do
	
        grep " ${beads[i]}    ${beads[j]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[i]}\_${beads[j]}.dat
        grep "S${beads[i]}   S${beads[j]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[i]}\_${beads[j]}.dat
	grep "T${beads[i]}   T${beads[j]}" martini_v3.0.0.itp | awk '{print $4 " " $5}' >> ${beads[i]}\_${beads[j]}.dat
        line_count=$(wc -l < "${beads[i]}_${beads[j]}.dat")
	count=$((count+line_count))

    done
done

echo "$total $count"

# grep "C1    C1" martini_v3.0.0.itp 
