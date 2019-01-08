#!/bin/sh
#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=120G

#SBATCH --job-name="hisat2_SE"
#SBATCH --requeue

# syntax:
# sbatch slurm-hisat2_SE -i [idxBasename] -r [sampleRootName]

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
SORTED_BAM_OUTPUT=${SAMPLE_ROOT}.sorted.bam
echo "SAMPLE_FILE_R1 = "$SAMPLE_FILE_R1
echo "SORTED_BAM_OUTPUT = "$SORTED_BAM_OUTPUT

# load  modules
echo "Loading Modules . . ."
module load samtools
module load gbc-hisat2
module list

echo "Running hisat2 . . . "
hisat2 --threads 12 \
	--new-summary \
	--summary-file ${SAMPLE_ROOT}.alignmentStats \
	-x $IDX_BASENAME \
	-U $SAMPLE_FILE_R1 | samtools sort -T tmp.${SAMPLE_ROOT} -@ 12 -O bam -o $SORTED_BAM_OUTPUT
# done
echo "All done!"

tend=`date`
echo "###### end time: $tend"

