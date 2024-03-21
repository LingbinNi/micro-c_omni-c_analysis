#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/contact_matrix/*C_*)
do
sample=$(basename $dir)
echo $sample
cd ./$sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -pe serial 4
#$ -o output_cool_to_h5.log
#$ -e error_cool_to_h5.log

module load hicexplorer/3.7.3

################################################################
## h5
################################################################

hicConvertFormat \
-m '$dir'/'$sample'.matrix_1kb.cool \
-o '$dir'/'$sample'.matrix_1kb.h5 \
--inputFormat cool \
--outputFormat h5

hicConvertFormat \
-m '$dir'/'$sample'.matrix_10kb.cool \
-o '$dir'/'$sample'.matrix_10kb.h5 \
--inputFormat cool \
--outputFormat h5

hicConvertFormat \
-m '$dir'/'$sample'.matrix_25kb.cool \
-o '$dir'/'$sample'.matrix_25kb.h5 \
--inputFormat cool \
--outputFormat h5

hicConvertFormat \
-m '$dir'/'$sample'.matrix_100kb.cool \
-o '$dir'/'$sample'.matrix_100kb.h5 \
--inputFormat cool \
--outputFormat h5
' > script_cool_to_h5.sh
qsub script_cool_to_h5.sh

cd ..
done
