#!/bin/sh
#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff

#SBATCH --nodes=1
##SBATCH --ntasks-per-node=3
#SBATCH --mem=4G

#SBATCH --job-name="fastqc-CBYU4ANXX"
#SBATCH --output=fastqc-CBYU4ANXX.sbatch.out
#SBATCH --mail-user=bjmarzul@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --requeue
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.


echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

cd $SLURM_SUBMIT_DIR
echo "working directory = "$SLURM_SUBMIT_DIR

module load gbc-fastqc
module list
ulimit -s unlimited
#

FLOWCELL_ID="CBYU4ANXX"
BASE_DIR="/projects/academic/gbcstaff/illumina/Demultiplexed/$FLOWCELL_ID/Unaligned"
PROJECT_DIRS=(Sim Gong Bladder)

echo "Launching fastqc!"

for projDir in ${PROJECT_DIRS[@]}
do
	workingDir=$BASE_DIR/$projDir
	for fastqFile in $workingDir/*.fastq.gz
	do
		#echo $fastqFile
		srun	--ntasts-per-node=3
			--mem=4G \
			--job-name="fastqc-FOOBAR" \
			--output=fastqc-FOOBAR.sbatch.out \
			--mail-user=bjmarzul@buffalo.edu \
			--mail-type=ALL 
				fastqc --threads 3 -o $workingDir/tmp_FastQC $fastqFile
	done
done


#
echo "All Done!"
