#!/usr/bin/sh
# Template to run TrimGalore on PE data. Copy to project folder.

### DO NOT CHANGE BELOW ###
UTILS="/projects/academic/gbcstaff/utils/slurm"
### DO NOT CHANGE ABOVE ###

echo "Launching TrimGalore PE!"

if [ ! -f ./TrimGalore ]; then
	echo "Creating output directory!"
	mkdir TrimGalore
fi

for fastqFile in $(ls *.fastq.gz | rev | cut -c 17- | rev | uniq)
do
	#echo $fastqFile
	sbatch $UTILS/trim_galore_PE.sbatch -1 ${fastqFile}_R1_001.fastq.gz -2 ${fastqFile}_R2_001.fastq.gz -a CTGTCTCTTATA -o TrimGalore  
done
wait
