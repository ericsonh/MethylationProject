#!/bin/bash
#SBATCH --job-name=methylation_project_1
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=30gb
#SBATCH --time=48:00:00
#SBATCH --output=/work/gene8940/he71286/log.%j
#SBATCH --mail-user=he71286@uga.edu
#SBATCH --mail-type=END,FAIL

#This script deals with anything to do with siles 737, 738, 739, and 740. Methylation_project_2 deals with the other four files.
#****IMPORTANT NOTE***** Start running this file AFTER the setup script has finished running

module load SRA-Toolkit/2.11.1-centos_linux64
module load Trim_Galore/0.6.5-GCCcore-8.3.0-Java-11-Python-3.7.4
module load Bismark/0.22.3-foss-2019b

mkdir /work/gene8940/he71286/methylation_project
mkdir /work/gene8940/he71286/methylation_project/bismarkout

OUT="/work/gene8940/he71286/methylation_project"
BISOUT="/work/gene8940/he71286/methylation_project/bismarkout"
BISREPORT="/work/gene8940/he71286/methylation_project/bismarkout/bismarkreport"

cd ${OUT}

# #Download dataset
# prefetch -O ${OUT} SRR333737 SRR333738 SRR333739 SRR333740
#
# for i in SRR333737 SRR333738 SRR333739 SRR333740
# do
#   fastq-dump --split-files ${OUT}/${i} -O ${OUT}
# done
#
# #data trimming
for i in SRR333737 SRR333738 SRR333739 SRR333740
do
  trim_galore --paired -o ${OUT}/${i}_trim ${OUT}/${i}_1.fastq ${OUT}/${i}_2.fastq
done
#
#methylation calling
for i in SRR333737 SRR333738 SRR333739 SRR333740
do
  bismark --genome ${OUT} -o ${BISOUT}/${i} -1 ${OUT}/${i}_trim/${i}_1_val_1.fq -2 ${OUT}/${i}_trim/${i}_2_val_2.fq
done

#deduplicating alignment files
for i in SRR333737 SRR333738 SRR333739 SRR333740
do
  deduplicate_bismark --bam --outfile ${i} --output_dir ${BISOUT}/${i} ${BISOUT}/${i}/${i}_1_val_1_bismark_bt2_pe.bam
done

#methylation extraction
for i in SRR333737 SRR333738 SRR333739 SRR333740
do
   bismark_methylation_extractor --gzip --comprehensive -o ${BISOUT}/${i} ${BISOUT}/${i}/${i}.deduplicated.bam
done
