#!/bin/bash
#written by Lingbin

for file in $(ls /net/eichler/vol28/projects/hgsvc/nobackups/analysis/c_based_data/*-C/*_{200M,400M,800M}_R*.fastq)
do
filename=$(basename $file .fastq)
echo $file > $filename.fofn
done
