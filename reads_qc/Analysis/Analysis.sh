#!/bin/bash
#written by Lingbin

for file in $(ls /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/fastp/*-C/*C_*/error.log)
do
sample=$(echo $file |awk -F "/" '{print $12}')
echo $sample > $sample.temp
cat $file| awk -F ": " '(NR>=26 && NR <=31) {print $2}' >> $sample.temp
done

echo Type > rowname.temp
cat /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/fastp/Micro-C/MicroC_2M/error.log| awk -F ": " '(NR>=26 && NR <=31) {print $1}' >> rowname.temp

paste -d"," rowname.temp *C*.temp > Analysis.csv

rm *temp
