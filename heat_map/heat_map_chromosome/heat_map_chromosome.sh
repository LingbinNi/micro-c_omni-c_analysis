#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/contact_matrix/*C_*)
do
dirname=$(basename $dir)
echo $dirname
mkdir $dirname
cd $dirname

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=50G
#$ -pe serial 1
#$ -o '$dirname'.o
#$ -e '$dirname'.e

module load hicexplorer

hicPlotMatrix \
-m '$dir'/*.matrix_100kb.cool \
-o '$dirname'.pdf \
--log1p \
--colorMap "Reds" \
--clearMaskedBins \
--chromosomeOrder chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM \
--perChromosome' > $dirname.sh
qsub $dirname.sh

cd ..
done
