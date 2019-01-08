#!/bin/sh
#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=124G

#SBATCH --job-name="bcl2fastq-"
#SBATCH --output=bcl2fastq-.sbatch.out
#SBATCH --mail-user=bjmarzul@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --requeue


echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

cd $SLURM_SUBMIT_DIR
echo "working directory = "$SLURM_SUBMIT_DIR

module load gbc-bcl2fastq
module list
ulimit -s unlimited
#

# /projects/academic/gbcstaff/illumina/Demultiplexed/CBYU8ANXX
FLOWCELL_ID=""
BASE_DIR="/projects/academic/gbcstaff/illumina"
RUNFOLDER_DIR="$BASE_DIR/Runs/171201_D00729_0011_ACBYU8/"
OUTPUT_DIR="$BASE_DIR/Demultiplexed/$FLOWCELL_ID/Unaligned/"

echo "Launch bcl2fastq!"

bcl2fastq --runfolder-dir $RUNFOLDER_DIR \
		--output-dir $OUTPUT_DIR \
		--interop-dir $OUTPUT_DIR \
		--stats-dir $OUTPUT_DIR \
#		--no-lane-splitting \
		--reports-dir $OUTPUT_DIR

#
echo "All Done!"
