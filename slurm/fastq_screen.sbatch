#!/bin/sh
#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff
#SBATCH --time=3:00:00
#SBATCH --ntasks=1
#SBATCH --mem=8000
#SBATCH --job-name="gbc-fastqc"
#Specifies that the job will be requeued after a node failure.
#The default is that the job will not be requeued.

# retreiving user inputed information
while getopts :i:o: option
do
	case "${option}"
	in
		o) workingDir=${OPTARG};;
		i) fastqFile=${OPTARG};;
	esac
done

echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

cd $SLURM_SUBMIT_DIR
echo "working directory = "$SLURM_SUBMIT_DIR

module use /projects/academic/gbcstaff/utils/modules/
module load bwa
module load gbc-fastq_screen
module list
ulimit -s unlimited
#

fastq_screen --aligner bwa --threads 1 -o $workingDir $fastqFile 2> $fastqFile\.screen.out

#
echo "All Done!"
