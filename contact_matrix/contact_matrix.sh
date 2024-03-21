#!/bin/bash
#written by Lingbin

for dir in $(ls -d /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/*C_*)
do
sample=$(basename $dir)
echo $sample
mkdir ./$sample
cd ./$sample

echo '#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l mfree=10G
#$ -l disk_free=10G
#$ -pe serial 16
#$ -o output.log
#$ -e error.log

module load pairix/0.3.7
module load cooltools
module load miniconda

#hic
#java -Xmx160000m -jar /net/eichler/vol28/home/lbni/software/nobackups/Juicer/juicer_tools_1.22.01.jar pre --threads 16 '$dir'/'$sample'.mapped.pairs '$sample'.contact_map.hic /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size
#cooler
ln -s '$dir'/'$sample'.mapped.pairs .
bgzip '$sample'.mapped.pairs
pairix '$sample'.mapped.pairs.gz
cooler cload pairix -p 16 /net/eichler/vol28/projects/hgsvc/nobackups/hic_cf_analysis/dovetail/DataBase/chr_size/hg38.chr.size:1000 '$sample'.mapped.pairs.gz '$sample'.matrix_1kb.cool
cooler zoomify --balance -p 16 '$sample'.matrix_1kb.cool' > script.sh
qsub script.sh

cd ..
done
