#!/bin/bash
##SBATCH --export=SLURM_CPUS_PER_TASK,SLURM_JOB_NAME,SLURM_NTASKS_PER_NODE,SLURM_PRIO_PROCESS,SLURM_SUBMIT_DIR,SLURM_SUBMIT_HOST
##SBATCH --job-name=cellranger_pipe
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --partition=largemem
#SBATCH --qos=largemem

# syntax:
# sbatch cellranger.sbatch -i [id] -n [path to bcl] -c [path to csv sample sheet] -g [path to genome] 

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
while getopts i:n:c:g: option
do
	case "${option}"
	in
		i) ID=${OPTARG};;
		n) RUN=${OPTARG};;
                c) CSV=${OPTARG};;
                g) GENOME=${OPTARG};;
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
module load gbc-anaconda
source activate py36
module list

OUT="/projects/academic/gbcstaff/illumina/10xgenomics/Analysis/"$ID
# launch job
echo "Running cellranger mkfastq on $RUN"


cellranger mkfastq --id=$ID --run=$RUN --csv=$CSV --outputdir=$OUT



echo "Cellranger mkfastq results are in "$OUT



## Loop for analysis of each sample 
for d in $OUT/*/; 
do echo "Starting Analysis on sample $d";
FASTQS="$OUT/outs/fastq_path";
CID=$(basename $d);
echo "Running cellranger count on $CID with fastq $FASTQS";
cellranger count --id=$CID --transcriptome=$GENOME --fastqs=$FASTQS --sample=$CID;
GTF="${GENOME}genes/genes.gtf";
echo "Running velocyto on sample $CID with gtf file $GTF";
VOUT="${d}outs/velocyto";
GEN="$(cut -d'-' -f4 <<<$GENOME)";
velocyto run -b $OUT/$CID/outs/filtered_gene_bc_matrices/$GEN/barcodes.tsv $OUT/outs/possorted_genome_bam.bam $GTF -o $VOUT -@ 32 -v;
echo "Output of velocyto: "$VOUT;
done



# done
echo "All done! ;)"
tend=`date`
echo "###### end time: $tend"

