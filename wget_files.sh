#!/bin/bash 

# this script will process a text file and download from the list of text files 
# my use case is for downloading fastqs

input_file="$1"
download_dir="$2"

if [ -z "$input_file" ] || [ -z "$download_dir" ]; then
    echo "Usage: $0 <input_file> <download_directory>"
    exit 1
fi 

mkdir -p "$download_dir" 

while IFS= read -r file; do
    echo "Downloading $file"
    wget -P "$download_dir" "$file" 
done < "$input_file"

echo "All done!" 
