#!/bin/sh
#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=120G

#SBATCH --job-name="bowtie2_PE"
#SBATCH --requeue

# syntax:
# sbatch slurm-bowtie2_PE -i [idxBasename] -r [sampleRootName]

tstart=`date`
echo "###### start time: $tstart"

# spit out some basic SLURM information
echo "SLURM_JOBID         = "$SLURM_JOB_ID
echo "SLURM_JOB_NAME      = "$SLURM_JOB_NAME
echo "SLURM_SUBMIT_DIR    = "$SLURM_SUBMIT_DIR
echo "SLURM_NODELIST      = "`nodeset -e $SLURM_NODELIST`
echo "SLURM_NPROCS        = "$SLURM_NPROCS
echo "SLURM_NNODES        = "$SLURM_NNODES
echo "SLURM_CPUS_PER_TASK = "$SLURM_CPUS_PER_TASK
echo "SLURMTMPDIR         = "$SLURMTMPDIR

# retreiving user inputed information
while getopts i:r: option
do
	case "${option}"
	in
                i) IDX_BASENAME=${OPTARG};;
		r) SAMPLE_ROOT=${OPTARG};;
	esac
done

# spit out user inputed information
echo "IDX_BASENAME  = "$IDX_BASENAME
echo "SAMPLE_ROOT  = "$SAMPLE_ROOT
SAMPLE_FILE_R1=${SAMPLE_ROOT}_R1_001.fastq.gz
SAMPLE_FILE_R2=${SAMPLE_ROOT}_R2_001.fastq.gz
SORTED_BAM_OUTPUT=${SAMPLE_ROOT}.sorted.bam
ALIGNMENT_STATS=${SAMPLE_ROOT}.alignmentStats
echo "SAMPLE_FILE_R1 = "$SAMPLE_FILE_R1
echo "SAMPLE_FILE_R2 = "$SAMPLE_FILE_R2
echo "SORTED_BAM_OUTPUT = "$SORTED_BAM_OUTPUT

# load  modules
echo "Loading Modules . . ."
module purge
module load gbc-samtools
module load gbc-bowtie2
module list

echo "Running bowtie2 . . . "
bowtie2 --threads 12 \
	-x $IDX_BASENAME \
	-1 $SAMPLE_FILE_R1 \
	-2 $SAMPLE_FILE_R2 \
	-x $IDX_BASENAME 2> $ALIGNMENT_STATS | samtools sort -@ 12 -O bam -o $SORTED_BAM_OUTPUT
# done
echo "All done!"

tend=`date`
echo "###### end time: $tend"

