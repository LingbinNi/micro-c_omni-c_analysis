#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hgsvc/nobackups/analysis/hic_cf_analysis/data/*-C)
do
dirname=$(basename $dir)
mkdir $dirname
cd $dirname

for file in $(ls $dir/*_R1.fastq)
do
filename=$(basename $file _R1.fastq)
echo $filename
mkdir $filename
cd $filename
echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -l disk_free=10G
#$ -pe serial 2
#$ -o output.log
#$ -e error.log

#command
/net/eichler/vol28/home/lbni/software/fastp/fastp \
--in1 '$dir'/'$filename'_R1.fastq \
--out1 '$filename'_R1.clean.fastq \
--in2 '$dir'/'$filename'_R2.fastq \
--out2 '$filename'_R2.clean.fastq
' > script.sh
qsub script.sh
cd ..
done

cd ..
done
