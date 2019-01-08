#!/bin/bash
#SBATCH --export=SLURM_CPUS_PER_TASK,SLURM_JOB_NAME,SLURM_NTASKS_PER_NODE,SLURM_PRIO_PROCESS,SLURM_SUBMIT_DIR,SLURM_SUBMIT_HOST
#SBATCH --job-name=trim_galore_PE
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8

#SBATCH --clusters=mae
#SBATCH --partition=gbc
#SBATCH --qos=gbc
#SBATCH --account=gbcstaff

# syntax:
# sbatch trim_galore_PE.sbatch -1 [R1 Fastq] -2 [R2 Fastq] -a [adapter to trim] -o [output dir]

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
while getopts 1:2:a:o: option
do
	case "${option}"
	in
		1) FILE1=${OPTARG};;
		2) FILE2=${OPTARG};;
                a) ADAPTER=${OPTARG};;
		o) OUTPUT=${OPTARG};;
	esac
done

echo "Fastq1 = "$FILE1
echo "Fastq2 = "$FILE2
echo "Adapter = "$ADAPTER
echo "Output = "$OUTPUT

# load  modules
echo "Loading Modules . . ."
module load gbc-cutadapt
module load gbc-fastqc
module load gbc-trim_galore

module list

# launch job
echo "Running trim_galore . . . "
trim_galore --paired --fastqc --fastqc_args "--threads 8" --adapter $ADAPTER --output_dir $OUTPUT $FILE1 $FILE2

# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

