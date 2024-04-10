#!/bin/bash

cd ~/main_GBS

module load cutadapt

for i in $(cat 190819_sample_list.txt); do
cutadapt -b TCGCTGTCTCTTATACACATCT $i/${i}_concatenated.fq.gz -o $i/${i}_trimmed.fq.gz 2> $i/${i}_cutadapt.err
done
