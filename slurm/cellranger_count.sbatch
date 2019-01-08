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
# sbatch cellranger_count.sbatch -i [id] -f [path to fastqs] -g [reference genome] -s [list of samples] 

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
while getopts i:f:g:s: option
do
	case "${option}"
	in
		i) ID=${OPTARG};;
                f) FASTQS=${OPTARG};;
                g) GENOME=${OPTARG};;
                s) SAMPLES=${OPTARG};;
	esac
done

# load bowtie module
echo "Loading Modules . . ."
module use /projects/academic/gbcstaff/utils/modules/
module load gbc-cellranger
module load gbc-bcl2fastq
module load gbc-anaconda
module load gbc-samtools
module load R
module list

# launch job
echo "Running cellranger mkfastq. . . "


echo "ID = "$ID
echo "GENOME = "$GENOME
echo "FASTQS = "$FASTQS
echo "SAMPLES = "$SAMPLES
GTF=$GENOME/genes/genes.gtf
voutput="Velocyto"
echo "GTF = "$GTF
echo "Velocyto_output = "$voutput
echo "Running cellranger count. . ."
cellranger count --id=$ID --transcriptome=$GENOME --fastqs=$FASTQS --sample=$SAMPLES 
echo "Cellranger count has finished. . . continuing into velocyto"
source activate py36

# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

