#!/bin/bash
#SBATCH --job-name=methylation_project
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=30gb
#SBATCH --time=48:00:00
#SBATCH --output=/work/gene8940/he71286/log.%j
#SBATCH --mail-user=he71286@uga.edu
#SBATCH --mail-type=END,FAIL

module load SRA-Toolkit/2.11.1-centos_linux64
module load Trim_Galore/0.6.5-GCCcore-8.3.0-Java-11-Python-3.7.4
module load Bismark/0.22.3-foss-2019b

mkdir /work/gene8940/he71286/methylation_project
mkdir /work/gene8940/he71286/methylation_project/bismarkout

OUT="/work/gene8940/he71286/methylation_project"
BISOUT="/work/gene8940/he71286/methylation_project/bismarkout"


cd ${OUT}

# #download necessary files
# #Reference genome
# curl -s https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/227/725/GCF_003227725.1_Cflo_v7.5/GCF_003227725.1_Cflo_v7.5_genomic.fna.gz \
# | gunzip -c > ${OUT}/Cflor_genomic.fa
#
# #Dataset
# prefetch -O ${OUT} SRR333737 SRR333738 SRR333744 SRR333743 SRR333741 SRR333742 SRR333740 SRR333739
#
# for i in SRR333737 SRR333738 SRR333744 SRR333743 SRR333741 SRR333742 SRR333740 SRR333739
# do
#   fastq-dump --split-files ${OUT}/${i} -O ${OUT}
# done

# #data trimming
# for i in SRR333737 SRR333738 SRR333744 SRR333743 SRR333741 SRR333742 SRR333740 SRR333739
# do
#   trim_galore --paired -o ${OUT}/${i}_trim ${OUT}/${i}_1.fastq ${OUT}/${i}_2.fastq
# done

# #Genome indexing using Bismark
# #NOTE: your genome file must end with the extension .fa, .fa.gz .fasta or .fasta.gz in order for Bismark to recognize it
# bismark_genome_preparation ${OUT} > ${OUT}/Cflor_genomic_index

# #testing bismark on 1 file
# bismark --genome ${OUT} -o ${BISOUT}/SRR333737 -1 ${OUT}/SRR333737_trim/SRR333737_1_val_1.fq -2 ${OUT}/SRR333737_trim/SRR333737_2_val_2.fq

# #methylation calling
# for i in SRR333737 SRR333738 SRR333744 SRR333743 SRR333741 SRR333742 SRR333740 SRR333739
# do
#   bismark --genome ${OUT} -o ${BISOUT}/${i} -1 ${OUT}/${i}_trim/${i}_1_val_1.fq -2 ${OUT}/${i}_trim/${i}_2_val_2.fq
# done

#testing deduplicating alignment files
#deduplicate_bismark --bam ${BISOUT}/SRR333737/SRR333737_1_val_1_bismark_bt2_pe.bam > ${BISOUT}/SRR333737/SRR333737_bis_dedup.bam

#testing methylation extractor
#bismark_methylation_extractor --gzip --comprehensive -o ${BISOUT}/SRR333737 ${BISOUT}/SRR333737/SRR333737_bis.deduplicated.deduplicated.bam

#testing bismark report command
bismark2report --dir ${BISREPORT} ${BISOUT}/SRR333741
