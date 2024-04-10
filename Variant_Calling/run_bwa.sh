#!/bin/bash

cd ~/main_GBS

module load bwa
module load samtools

FASTA='zizania_palustris_13Nov2018_okGsv_renamedNCBI2.fasta'

# FASTA file must be indexed first
bwa index $FASTA

for i in $(cat 190815_sample_directory_list.txt); do
bwa mem -t 32 $FASTA $i/${i}_trimmed.fq.gz 2> $i/${i}_bwa.err | samtools sort -o $i/${i}_sorted.bam 2> $i/${i}_samtools_sort.err;
done
