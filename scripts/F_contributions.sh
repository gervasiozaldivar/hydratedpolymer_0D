for c in IEC*; do 

for r in 01 05 15 25 35 45 55 65 75 85 95 99; do 
  cd $c/RH$r

  i=`awk '{print $1}' volfraction.min.dat`

  for j in F_*.dat; do 
    jj="${j%.dat}"
    echo $r `grep $i $j | awk '{print $3}'` >> ../../$jj\_vs_RH-$c.dat
  done
  cd ../..
done
done
