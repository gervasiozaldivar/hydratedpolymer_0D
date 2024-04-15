for c in IEC*; do 

for r in 01 05 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 ; do 
  cd $c/RH$r

  i=`awk '{print $1}' volfraction.min.dat`

  for j in F_*.dat; do 
    jj="${j%.dat}"
    echo $r `grep $i $j | awk '{print $3}'` >> ../../$jj\_vs_RH-$c.dat
  done
  cd ../..
done
done
