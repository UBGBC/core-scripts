#!/usr/bin/sh
# Template to run hisat2. Copy over to the project folder and edit the variables below.

#Update the idxBasename
IDX_BASENAME=PUT-IDX_BASENAME-path-here

### DO NOT CHANGE BELOW ###
UTILS="/projects/academic/gbcstaff/utils/slurm"
### DO NOT CHANGE ABOVE ###

echo "Launching hisat2"

for i in $(ls *.fastq.gz | rev | cut -c 17- | rev | uniq)
do
        #echo $i;
        #echo $IDX_BASENAME;
        sbatch $UTILS/hisat2_PE.sbatch -i $IDX_BASENAME -r $i
	wait
done
wait
