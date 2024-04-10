#!/bin/bash

cd ~/main_GBS

module load python3

# prepend header to our output file
echo $'sample_name\tQC_passed_reads\tmapped_reads\tpercentage_mapped' > flagstat_summary.txt

# iterate through flagstat output files and extract desired info (mapped reads + % mapped)
# loop also grabs the sample name (from shell/loop variable and exports it to python to write name to file w/ corresponding data)
for i in $(cat sample_list.txt); do
var=$(echo ${i})
export var
python  parse_flagstat_files.py ${i}/${i}_bam_flagstat_output.txt flagstat_summary.txt
done
