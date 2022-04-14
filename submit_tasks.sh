## CONTENTS ##
RAW_FN=/path/to/location/of/filenames/*.txt      #file with names of files containing raw reads, with one read per line (R1 first followed by R2 below it)

N_LINES=$(wc -l < "$RAW_FN") 
N_SAMPLES=$((N_LINES / 2))
                                       #number of samples
echo $N_SAMPLES

declare -A READS                                   #array
i=1
j=1

while read -r LINE                                 #reads each filename at a time, stores names in array 
do
   if [ "$j" -eq 1 ]
   then
      READS[$i,1]=$LINE
      let "j=2"

   else
      READS[$i,2]=$LINE
      let "i+=1"
      let "j=1"
   fi

done < ${RAW_FN}


# navigate to output folder
cd /path/to/project/folder/                              #cd to project folder


for i in `seq 1 1 $N_SAMPLES`; do
   DNAFILE_A=${READS[$i,1]}
   DNAFILE_B=${READS[$i,2]}
   echo $FASTAFILE_A                                          #display fastq file names R1
   echo $FASTAFILE_B											#display fastq file names R2
   sbatch /path/to/the/script/that/hastheruninfo.sh $FASTAFILE_A  $FASTAFILE_B   #starts job
   sleep 1                                                  #pauses for 1 sec
   echo
done
