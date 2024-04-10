module load htslib
module load parallel

export bams="190910_sorted_bam_files.txt"
export prefix="210306_samtools"
export ref="zizania_palustris_13Nov2018_okGsv_renamedNCBI2.fasta"

parallel_samtools_processes=15

mkdir -p $prefix
cut -f 1 ${ref}.fai


scythe_mpileup() {
        REGIONS=${1}
        SCAFFOLD=$(echo ${REGIONS} | cut -f 1 -d ";")
        samtools mpileup -q 20 -gDVu \
                -b $bams \
                -r ${REGIONS} \
                -f ${ref} \
                | bcftools call -mv \
                | bgzip -c \
                > $prefix/${prefix}_${SCAFFOLD}.vcf.gz \
                2> $prefix/${prefix}_${SCAFFOLD}.err
}

export -f scythe_mpileup

parallel --will-cite -j $parallel_samtools_processes scythe_mpileup ::: $(cut -f 1 ${ref}.fai)
