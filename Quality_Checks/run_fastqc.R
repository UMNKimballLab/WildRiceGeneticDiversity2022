cd ~/main_GBS

# Load fastQC
module load fastqc

# Run fastQC on trimmed reads
for i in $(cat 190515_sample_list,txt); do
fastqc $i/${i}_R1_001_trimmed.fastq.gz;
done
