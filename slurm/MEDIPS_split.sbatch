#!/bin/bash
#SBATCH --export=SLURM_CPUS_PER_TASK,SLURM_JOB_NAME,SLURM_NTASKS_PER_NODE,SLURM_PRIO_PROCESS,SLURM_SUBMIT_DIR,SLURM_SUBMIT_HOST
#SBATCH --job-name=cellranger_pipe
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --partition=largemem
#SBATCH --qos=largemem

# syntax:
# sbatch cellranger.sbatch -i [id] -n [path to bcl] -c [csv sample sheet] -g [genome] -s [list of samples] -o [outputdir] -r [rscript]

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
while getopts m:o option
do
	case "${option}"
	in
		m) META=${OPTARG};;
                o) OUT=${OPTARG};;
	esac
done

# load bowtie module
echo "Loading Modules . . ."
module use /projects/academic/gbcstaff/utils/modules/
module load R
module list

# launch job
echo "Running MEDIPS . . "


echo "input file = "$META
echo "output file = "$OUT
Rscript /projects/academic/mjbuck/Sethi-MeDip/MeDip_study.r $META $OUT

# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

