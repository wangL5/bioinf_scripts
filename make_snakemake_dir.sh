#!/bin/bash

# quick script to make directories within a snakemake project directory

mkdir -p workflow
mkdir -p workflow/envs
touch workflow/snakefile
mkdir -p config
mkdir -p results 

echo "All done!"