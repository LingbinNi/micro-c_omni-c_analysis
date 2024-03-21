#!/bin/bash
#written by Lingbin

module load miniconda/4.8.3

for file in $(ls /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/*/hic/GM12878/assemblies/hifiasm_ont/hic/0.19.5/GM12878.hifiasm.hic.hap*.p_ctg.gfa.fasta.fai)
do
echo $file | awk -F "/" '{print $11,$18}'
/net/eichler/vol26/7200/software/pipelines/compteam_tools/n50 $file
done

cat temp | sed 's/://g' | sed 's/ \{2,\}/ /g' | sed 's/ (/(/g' | sed 's/ /,/g' | sed '/^$/d' > run.csv

rm temp
