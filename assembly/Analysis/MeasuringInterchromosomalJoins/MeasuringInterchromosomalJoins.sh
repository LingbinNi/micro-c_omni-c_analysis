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
#$ -pe serial 4
#$ -o output.log
#$ -e error.log

module load minigraph
module load minimap2

minigraph \
-cxasm \
/net/eichler/vol28/eee_shared/assemblies/CHM13/T2T/v2.0/T2T-CHM13v2.fasta \
'$file' \
-o '$data'-'$hap'

paftools.js misjoin '$data'-'$hap'
' > script.sh
qsub script.sh

cd ..
done
