#!/usr/bin/sh
# Template to run bowtie2. Copy over to the project folder and edit the variables below.

#Update the idxBasename
IDX_BASENAME=/projects/academic/gbcstaff/Core_Projects/bjmarzul/PropionibacteriumAcnes/ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/008/345/GCF_000008345.1_ASM834v1/genome

### DO NOT CHANGE BELOW ###
UTILS="/projects/academic/gbcstaff/utils/slurm"
### DO NOT CHANGE ABOVE ###

echo "Launching bowtie2 PE"

for i in $(ls *.fastq.gz | rev | cut -c 17- | rev | uniq)
do
        #echo $i;
        #echo $IDX_BASENAME;
        sbatch $UTILS/bwamem_PE.sbatch -i $IDX_BASENAME -r $i
	wait
done
wait
