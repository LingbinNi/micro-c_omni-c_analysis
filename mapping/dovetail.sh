#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/fastp/*-C/*)
do
sample=$(basename $dir)
echo $sample
mkdir ./$sample
cd ./$sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=20G
#$ -l disk_free=10G
#$ -pe serial 16
#$ -o output.log
#$ -e error.log

module load bedtools
module load deeptools
module load pairtools
module load bwa/0.7.17
module load samtools/1.19
module load preseq
module load miniconda

#Alignment
bwa mem -5SP -T0 -t16 /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/DataBase/reference/hg38.no_alt.fa '$dir'/'$sample'_R1.clean.fastq.gz '$dir'/'$sample'_R2.clean.fastq.gz -o '$sample'.aligned.sam
#Recording valid ligation events
pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in 8 --nproc-out 8 --chroms-path /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size '$sample'.aligned.sam > '$sample'.parsed.pairsam
#Sorting the pairsam file
mkdir -p /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/'$sample'/temp
pairtools sort --nproc 16 --tmpdir=/net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/'$sample'/temp/ '$sample'.parsed.pairsam > '$sample'.sorted.pairsam
#Removig PCR duplicates
pairtools dedup --nproc-in 8 --nproc-out 8 --mark-dups --output-stats stats.txt --output '$sample'.dedup.pairsam '$sample'.sorted.pairsam
#Generate .pairs and bam files
pairtools split --nproc-in 8 --nproc-out 8 --output-pairs '$sample'.mapped.pairs --output-sam '$sample'.unsorted.bam '$sample'.dedup.pairsam
#Generating the final bam file
samtools sort -@16 -T /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/'$sample'/temp/temp.bam -o '$sample'.mapped.PT.bam '$sample'.unsorted.bam
#Index the bam file
samtools index '$sample'.mapped.PT.bam' > script.sh
qsub script.sh

cd ..
done
