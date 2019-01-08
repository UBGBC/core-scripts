#!/bin/bash
#SBATCH --export=SLURM_CPUS_PER_TASK,SLURM_JOB_NAME,SLURM_NTASKS_PER_NODE,SLURM_PRIO_PROCESS,SLURM_SUBMIT_DIR,SLURM_SUBMIT_HOST
#SBATCH --job-name=miRNA_pipe
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8

# syntax:
# sbatch mirna-v0.01.sbatch -g [bowtie2 index] -a [fastq file] -t [adapter to trim] -o [output]

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
while getopts g:i:t:o: option
do
	case "${option}"
	in
		g) GENOME=${OPTARG};;
		i) FILE1=${OPTARG};;
                t) ADAPTER=${OPTARG};;
		o) OUTPUT=${OPTARG};;
	esac
done

echo "genome = "$GENOME
echo "file1  = "$FILE1
rootname=$( basename "$FILE1" .fastq.gz )
echo "rootname = $rootname"
echo "output = "$OUTPUT

# load bowtie module
echo "Loading Modules . . ."
module load gbc-bowtie2
module load gbc-samtools
module load gbc-cutadapt
module load gbc-fastqc
module load gbc-trim_galore
module load bwa

module list

# launch job
echo "Running trim_galore . . . "
trim_galore --length 15 --fastqc --fastqc_args "--threads 8" $FILE1

echo "Launching Bowtie2 . . ."
#bowtie2 --threads 8 --very-sensitive-local -x $GENOME -U $rootname\_trimmed.fq.gz 2>$rootname\.alignmentStats.txt | samtools view -bS - | samtools sort -T $rootname.tmp -@8 -O bam > $rootname\.trimmed.sorted.bam
bwa aln -t 8  $GENOME $rootname\_trimmed.fq.gz > $rootname\_trimmed.fq.sa.sai
bwa samse $GENOME $rootname\_trimmed.fq.sa.sai $rootname\_trimmed.fq.gz > $rootname\_trimmed.sam
# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

