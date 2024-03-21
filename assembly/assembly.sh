#!/bin/bash
#written by Lingbin

for file in $(ls /net/eichler/vol28/projects/hgsvc/nobackups/analysis/c_based_data/*-C/*_{200M,400M,800M}_R1.fastq)
do
filename=$(basename $file _R1.fastq)
mkdir $filename
cd $filename

cp -r /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/hic .
echo -e 'sample	hifi_fofn	ont_fofn	hic_r1_fofn	hic_r2_fofn
GM12878	/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/fofn/hifi_fastq.fofn	/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/fofn/ont_fastq.fofn	/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/fofn/'$filename'_R1.fofn	/net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/fofn/'$filename'_R2.fofn
' > ./hic/manifest.tab

################################################################
## cluster
################################################################

snakemake --ri --jobname "{rulename}.{jobid}" \
--drmaa " -l centos=7 -V -cwd -j y -o ./log -e ./log -l h_rt=72:00:00 -l mfree=10G -pe serial 16 -w n -S /bin/bash" \
-w 60 -j 32 -k -p --use-envmodules \
-s /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/OmniC_800M/hic/Snakefile

################################################################
## ocelot/liger
################################################################

snakemake -s /net/eichler/vol28/projects/hic_cohorts/nobackups/00.Analysis/omnic_microc_cf_analysis/assembly/OmniC_200M/hic/Snakefile -j 32 -k -p --use-envmodules

cd ..
done
