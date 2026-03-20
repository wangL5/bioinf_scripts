#!/bin/bash

# this script downloads NCBI refseq representative genomes from a list of species. Genus level ok.

# assign argument file to variable
input_file="$1"

if [ -z "$input_file" ]; then
        echo "Usage: $0 <input_file>"
        exit 1
fi

while IFS= read -r species; do
        echo "Downloading $species"
        datasets download genome taxon "$species" --reference \
                --filename "${species// /_}.genomes.zip"
done < "$input_file"
