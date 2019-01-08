#!/bin/bash
#SBATCH --export=SLURM_CPUS_PER_TASK,SLURM_JOB_NAME,SLURM_NTASKS_PER_NODE,SLURM_PRIO_PROCESS,SLURM_SUBMIT_DIR,SLURM_SUBMIT_HOST
#SBATCH --job-name=cellranger_pipe
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8

# syntax:
# sbatch cellranger.sbatch -i [id] -n [path to bcl] -c [csv sample sheet] -g [genome] -s [list of samples] -o [outputdir]

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
while getopts i:n:c:g:s:o: option
do
	case "${option}"
	in
		i) ID=${OPTARG};;
		n) RUN=${OPTARG};;
                c) CSV=${OPTARG};;
                g) GENOME=${OPTARG};;
                s) SAMPLES=${OPTARG};;
                o) OUT=${OPTARG};;
	esac
done

echo "ID = "$ID
echo "RUN  = "$RUN
echo "SampleSheet  = "$CSV

# load bowtie module
echo "Loading Modules . . ."
module use /projects/academic/gbcstaff/utils/modules/
module load gbc-cellranger
module load gbc-bcl2fastq
module list

# launch job
echo "Running cellranger mkfastq. . . "
cellranger mkfastq --id=$ID --run=$RUN --csv=$CSV



echo "OUTPUT = "$OUT
FASTQS=$("$OUT" /outs/fastq_path )
VDJ=$("$ID" _VDJ )
echo "FASTQS = "$FASTQS
echo "SAMPLES = "$SAMPLES
echo "Running cellranger vdj. . ."
cellranger vdj --id=$VDJ --reference=$GENOME --fastqs=$FASTQS --sample $SAMPLES 


# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

