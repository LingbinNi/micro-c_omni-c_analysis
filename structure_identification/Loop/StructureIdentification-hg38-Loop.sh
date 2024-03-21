#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/contact_matrix/*C_*)
do
sample=$(basename $dir)
echo $sample
mkdir $sample
cd $sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -pe serial 4
#$ -o '$sample'.o
#$ -e '$sample'.e

module load hicexplorer/3.7.3

################################################################
## loop
################################################################

hicDetectLoops \
-m '$dir'/'$sample'.matrix_10kb.cool \
-o '$sample'_max2000000_window10_peak6_pvaluepre0.05_pvalue0.05.bedgraph \
--maxLoopDistance 2000000 \
--windowSize 10 \
--peakWidth 6 \
--pValuePreselection 0.05 \
--pValue 0.05 \
--threads 4' > script.sh
qsub script.sh

cd ..
done
