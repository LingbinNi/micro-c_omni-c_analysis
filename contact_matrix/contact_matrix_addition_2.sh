#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail/*C_*)
do
sample=$(basename $dir)
echo $sample
cd ./$sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -pe serial 4
#$ -o output_addition.log
#$ -e error_addition.log

module load pairix/0.3.7
module load cooltools
module load miniconda

#cooler
cooler cload pairix -p 4 /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size:10000 '$sample'.mapped.pairs.gz '$sample'.matrix_10kb.cool
cooler cload pairix -p 4 /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size:25000 '$sample'.mapped.pairs.gz '$sample'.matrix_25kb.cool
cooler cload pairix -p 4 /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size:100000 '$sample'.mapped.pairs.gz '$sample'.matrix_100kb.cool
' > script_addition.sh
qsub script_addition.sh

cd ..
done
