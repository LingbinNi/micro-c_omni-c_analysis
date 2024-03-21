#!/bin/bash
#written by Lingbin

for file in $(ls /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/*/hic/GM12878/assemblies/hifiasm_ont/hic/0.19.5/GM12878.hifiasm.hic.hap*.p_ctg.gfa.fasta)
do
data=$(echo $file | awk -F "/" '{print $11}')
hap=$(echo $file | awk -F "/" '{print $18}' | awk -F "." '{print $4}')
echo $data-$hap
mkdir $data-$hap
cd $data-$hap

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -pe serial 16
#$ -o output.log
#$ -e error.log

module load yak

################################################################
## QV
################################################################

yak qv \
-t 16 \
-p -K 3.2g \
-l 100k \
/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/Analysis/03.AssemblyQVAssessment-Yak/Kmer/OmniC_800M/OmniC_800M.yak \
'$file'
' > script.sh
qsub script.sh

cd ..
done
