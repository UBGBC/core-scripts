#!/usr/bin/sh
# Template to run lane QC (FastQC, FastqScreen). Copy over to the Demultiplexed folder, and edit the four variables below

#Update the FCID
FLOWCELL_ID="[PUT-FCID-HERE]"
PROJECT_DIRS=([PUT-PI-NAME-HERE)
GENOME=PATH_TO_BOWTIE2_INDEXES
### DO NOT CHANGE BELOW ###
UTILS="/projects/academic/gbcstaff/utils/slurm"
BASE_DIR="/projects/academic/gbcstaff/illumina/Demultiplexed/$FLOWCELL_ID/Unaligned"
### DO NOT CHANGE ABOVE ###

echo "Launching fastqc!"

for projDir in ${PROJECT_DIRS[@]}
do
	workingDir=$BASE_DIR/$projDir
	mkdir $workingDir/Aligned
	for fastqFile in $workingDir/*.fastq.gz
	do
		#echo $fastqFile
		sbatch $UTILS/miRNA.sbatch -o $workingDir/Aligned -i $fastqFile -g $GENOME 
	done
	wait
done
wait
