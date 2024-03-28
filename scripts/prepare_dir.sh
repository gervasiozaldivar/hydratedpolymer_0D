for i in {05..95..5}; do  
  cp RH55/fort.8 RH$i
  mu=`awk -v target="$i" '$1 == target {print $2}'  mu_vs_RH.dat `
  echo $i $mu
  sed -i "s/-13.286230069422874/$mu/g" RH$i/fort.8
done 
