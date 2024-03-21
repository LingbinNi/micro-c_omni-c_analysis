#!/bin/bash
#written by Lingbin

for file in $(ls /net/eichler/vol28/projects/hgsvc/nobackups/analysis/c_based_data/*-C/*_R1.fastq)
do
sample=$(basename $file _R1.fastq)
file2=$(echo $file|sed 's/R1/R2/g')
echo $sample
mkdir ./$sample
cd ./$sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=5G
#$ -pe serial 16
#$ -o output.log
#$ -e error.log

module load yak

################################################################
## kmer
################################################################

yak count \
-t16 \
-b37 \
-o '$sample'.yak \
<(cat '$file') \
<(cat '$file2')
' > script.sh
qsub script.sh

cd ..
done
