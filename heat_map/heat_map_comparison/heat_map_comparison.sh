#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/contact_matrix/OmniC_*)
do
dirname=$(basename $dir)
res=${dirname##*_}
echo $dirname\_MicroC_$res
mkdir $dirname\_MicroC_$res
cd $dirname\_MicroC_$res

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=100G
#$ -pe serial 1
#$ -o '$dirname'_MicroC_'$res'.o
#$ -e '$dirname'_MicroC_'$res'.e

module load hicexplorer

hicCompareMatrices \
--matrices /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/contact_matrix/MicroC_'$res'/MicroC_'$res'.matrix_100kb.h5 '$dir'/OmniC_'$res'.matrix_100kb.h5 \
--outFileName MicroC_over_OmniC_log2_'$res'.h5 \
--operation log2ratio

hicPlotMatrix \
-m MicroC_over_OmniC_log2_'$res'.h5 \
-o MicroC_over_OmniC_log2_'$res'.pdf \
--clearMaskedBins \
--chromosomeOrder chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM \
--perChromosome
' > $dirname\_MicroC_$res.sh
qsub $dirname\_MicroC_$res.sh

cd ..
done
