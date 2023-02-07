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

#This script deals with setting everything up for the other scripts to run properly. This includes fetching and indexing the reference genome.
#****IMPORTANT NOTE**** You MUST run this script first, and then submit scripts 1 and 2.

module load SRA-Toolkit/2.11.1-centos_linux64
module load Bismark/0.22.3-foss-2019b

mkdir /work/gene8940/he71286/methylation_project
mkdir /work/gene8940/he71286/methylation_project/bismarkout

OUT="/work/gene8940/he71286/methylation_project"
BISOUT="/work/gene8940/he71286/methylation_project/bismarkout"

cd ${OUT}

#download necessary files
#Reference genome
curl -s https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/227/725/GCF_003227725.1_Cflo_v7.5/GCF_003227725.1_Cflo_v7.5_genomic.fna.gz \
| gunzip -c > ${OUT}/Cflor_genomic.fa

#Genome indexing using Bismark
#NOTE: your genome file must end with the extension .fa, .fa.gz .fasta or .fasta.gz in order for Bismark to recognize it
bismark_genome_preparation ${OUT} > ${OUT}/Cflor_genomic_index
