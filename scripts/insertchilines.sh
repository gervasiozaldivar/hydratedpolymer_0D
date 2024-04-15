# This script inserts chi data into an old fort.8. 
# Line and dir must be defined.
# For IEC100 define line as 12. For IEC<100 define line as 13. 
# Exaple for IEC=100, bash insertchilines.sh 12 `pwd`
#!/bin/bash

sed -i "$1i\
# chi #\n\
0." $2/fort.8
