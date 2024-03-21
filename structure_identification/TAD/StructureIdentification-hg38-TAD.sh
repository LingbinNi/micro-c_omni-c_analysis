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
## tad
################################################################

hicFindTADs \
-m '$dir'/'$sample'.matrix_10kb.cool \
--outPrefix '$sample'_min30000_max100000_step10000_thres0.05_delta0.01_fdr \
--minDepth 30000 \
--maxDepth 100000 \
--step 10000 \
--thresholdComparisons 0.05 \
--delta 0.01 \
--correctForMultipleTesting fdr \
-p 4' > script.sh
qsub script.sh

cd ..
done
