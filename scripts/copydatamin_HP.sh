awk '{print $1 " " $3}' F_tot.dat > F_tot.dat-ord

npol=`~/develop/fmin_and_size/findmin_ftot | awk '{print $2}' #| sed -s 's/00//'`


# npol=`grep "$Fmin" F_tot.dat | awk '{print $1}'`

echo $npol

grep  "$npol" volfraction.001.dat > volfraction.min.dat


mkdir datamin

for i in F_* fractionNplus.001.dat mupol.001.dat; do
  grep "$npol" $i > datamin/$i
done



