#!/bin/bash

# summarize the outputs from assembly-stats into an output table 

# TO DO - instead of grabbing the sample name from the assembly-stats output, get it using basename or dirname

# activate env 
eval "$(conda shell.bash hook)"
conda activate misc_tools

# inputs 
input_dir="$1"
data_type="$2"

# input check 
if [[ -z "$input_dir" || -z "$data_type" || ("$data_type" != "megahit" \
    && "$data_type" != "metaspades" && "$data_type" != "fastq") ]]; then
    echo "Usage: $0 <input_directory> <data_type>"
    echo "Data type: megahit, metaspades, or fastq"
    echo "gzipped files are ok" 
    exit 1
fi 

# output
output_file="assembly_stats_summary.txt"
touch "$output_file"
echo -e "Sample\tSum_bases\tNum_contigs\tN50\tLargest_contig" >> "$output_file"

if [[ "$data_type" == "megahit" ]]; then 
    FILEPATH="${input_dir}/*/final.contigs.fa"
elif [[ "$data_type" == "metaspades" ]]; then
    FILEPATH="${input_dir}/*/scaffolds.fasta"
elif [[ "$data_type" == "fastq" ]]; then
    FILEPATH="${input_dir}/*"
fi

for FILE in ${FILEPATH}; do
    TMP_STATS=$(assembly-stats "$FILE")
    # TODO: add error handling for empty TMP_STATS file 
    SAMPLE=$(echo "$TMP_STATS" | grep -P -o "(?<=stats for ).*")
    SUM=$(echo "$TMP_STATS" | grep -P -o "(?<=sum = )\d+(?=,)")
    N=$(echo "$TMP_STATS" | grep -P -o "(?<=n = )\d+(?=,)")
    N50=$(echo "$TMP_STATS" | grep -P -o "(?<=N50 = )\d+(?=,)")
    LARGEST=$(echo "$TMP_STATS" | grep -P -o "(?<=largest = )\d+")
    echo -e "$SAMPLE\t$SUM\t$N\t$N50\t$LARGEST" >> "$output_file"
done

echo "All done!" 
