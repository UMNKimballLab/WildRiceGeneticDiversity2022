#!/bin/bash

cd ~/main_GBS

module load samtools

for i in $(cat sample_list.txt); do
samtools flagstat ${i}/${i}_sorted.bam > ${i}/${i}_bam_flagstat_output.txt
done
