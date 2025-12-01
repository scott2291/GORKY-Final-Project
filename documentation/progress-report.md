# Progress Report

## Script Overview

### File Preparation

    - I will start by downloading all of my necessary files: M82 fasta file, Heinz1706 fasta file, EA03058 fastq files, and EA03058 VCF file.
    - Using `bcftools` to filter the VCF file for chromosome 3 and extract that information into a new file.
    - Filter for indel #5 using the `grep`, `awk` and `sed` commands
        - From the output of these commands I should be able to see the position range for indel 5
    -I will then use a bash script (maybe batch job), to use SeqKit to create trimmed fasta and fastq files that only contain indel 5.

Script 1: index reference genomes
    - use functions `bwa` and `samtools`
    - contains a chunk of code for both Heinz1706 and M82

### Align reads to refernce

Script 2: 
    - uses `bwa` and `samtools` to algin the paired-end reads to the reference genomes
        - `bwa` for the alignment
        - `samtools` for converting the SAM file to a BAM file
        -`samtools` to sort the BAM file for future analysis

### Call Variants

Script 3:
    - Uses `bcftools` and `samtools` to generate a pileup and call variants
    - creates an VCF file as the output
    - Uses `bcftools` to index the VCF file

### Filter for Deletions

Script 4:
    - Extracts deletions using `bcftools`
    - creates a new vcf file that contains deletions only

### Visualize in R

Script 5:
    - Use libraries `tidyverse` and `vcfR`
    - load vcf data into R as an object
    - plot the deletion positions as a heatmap or histogram

### Quarto Documentation

This document will contain the detailed workflow for this project with a reproducible procedure 