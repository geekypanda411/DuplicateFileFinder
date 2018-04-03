#SCRIPT WHICH FINDS DUPLICATE FILES IN A GIVEN DIRECTORY
echo "Enter the Absolute path of the directory you want to check for Duplicate files in."
# Read directory path
read in_path
#set directory files in positional parameters
set $(ls $in_path)
#Delete previous .list file
rm .listofhcfiles
rm .listofhchashes
rm .listofhcnames
rm .listofhcallhash
#variable for upper limit of count
numofiles=$#
#variable for Initail count start
count=1
#While count is less then upper limit keep on appending sha and skip if directory
while [ $count -le $numofiles ]
do
  if [ -d ${!count} ]
  then
      echo "Directory ${!count} skipped!"
  else
      shasum $in_path/${!count}>>.listofhcfiles
  fi
  count=`expr $count + 1`
done
#cat .listofhcfiles
#Slicing out hashes from .listofhcfiles
cut -d " " -f 1 .listofhcfiles>>.listofhcallhash
set $( cat .listofhcallhash )
mvalhc=$#
hashc=1
# while hashc is less than max and has2c is less than max compare and find out hashes that are same and output toa file
while [ $hashc -le $mvalhc ]
do
  hash2c=`expr $hashc + 1`
  while [ $hash2c -le $mvalhc ]
  do
    if [ ${!hashc} == ${!hash2c} ]
    then
        echo ${!hashc}>>.listofhchashes
    fi
    hash2c=`expr $hash2c + 1`
  done
  hashc=`expr $hashc + 1`
done
#Getting back file names from hash values 
set $( cat .listofhchashes )
maxval=$#
echo $#" Sets of Duplicate files found!"
val=1
while [ $val -le $maxval ]
do
  string=$( cat .listofhcfiles | grep ${!val} )
  string2=$( echo $string | cut -d " " -f 2,4 )
  echo $string2>>.listofhcnames
  val=`expr $val + 1`
done
echo "Following Files (opposite to each other) are duplicate of each other:"
cat .listofhcnames
cat .listofhcnames >> Duplicate_file_list
#asking user which one to delete
#set &( cat .listofhcnames )
#maxhereval=$#
#navl=1
#nnval=1
#while [ $nval -le $maxhereval ]
#do
#  nnval=`expr $nval + $maxhereval`
#  echo "In Set $nval of duplicate files, which one would you like to \ndelete? Enter 1 or 2 for appropriate choice."
#  echo "1) ${!nval} \n2) ${!nnval}"
#  read delvar
#  if [ $delvar == 1 ]
#  then
#     rm ${!nval} && echo "${!nval} deleted!"
#  elif [ $delvar == 2 ]
#  then
#     rm ${!nnval} && echo "${!nnval} deleted"
#  else
#     echo "ONLY 1 AND 2 ACCEPTED AS INPUT"
#  fi
#  nval=`expr $nval + 1`
#done
