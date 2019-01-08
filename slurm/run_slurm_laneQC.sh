#!/usr/bin/sh
# Template to run lane QC (FastQC, FastqScreen). Copy over to the Demultiplexed folder, and edit the four variables below

#Update the FCID
FLOWCELL_ID="H5VHYAFXY"
PROJECT_DIRS=(Tactiva_Pool1)

### DO NOT CHANGE BELOW ###
UTILS="/projects/academic/gbcstaff/utils/slurm"
BASE_DIR="/projects/academic/gbcstaff/illumina/Demultiplexed/$FLOWCELL_ID/Unaligned"
### DO NOT CHANGE ABOVE ###

echo "Launching fastqc!"

for projDir in ${PROJECT_DIRS[@]}
do
	workingDir=$BASE_DIR/$projDir
	mkdir $workingDir/FastQC
	mkdir $workingDir/FastqScreen
	for fastqFile in $workingDir/*.fastq.gz
	do
		#echo $fastqFile
		sbatch $UTILS/fastqc.sbatch -o $workingDir/FastQC -i $fastqFile
		sbatch $UTILS/fastq_screen.sbatch -o $workingDir/FastqScreen -i $fastqFile
	done
	wait
done
wait
