# Progress Report

## Script Overview

### File Preparation

    - I will start by downloading all of my necessary files: M82 fasta file, Heinz1706 fasta file, EA03058 fastq files, and EA03058 VCF file.

    - I also have a setting up section of my README.md that allows establishes my constant variables and prepares my files for manipulation

Script 1: `indel_position.sh`

    - this script should give the starting and ending position on chromosome three for my region of interest.
    - see script for details

Script 2: `seqkit.sh`

    - this script takes the fasta files, and trims them to only include the region that we are interested in on chromosome 3. The fastq file reads will then only be aligned in the areas that our corrected fasta file has data


### Run fastqc

Script 3: `fastqc.sh`

    - this will run fastqc on all the fastq files in the data/fastq directory
    - slurm bacth job

Script 3b: `trimgalore.sh`

    -this script will be created depending on the quality of the reads as determined by the `fastqc.sh` script


### Align reads to refernce

Script 4: 
    - uses `bwa` and `samtools` to algin the paired-end reads to the reference genomes
        - `bwa` for the alignment
        - `samtools` for converting the SAM file to a BAM file
        -`samtools` to sort the BAM file for future analysis

### Call Variants and Filter for Deletions

Script 4:
    - Uses `bcftools` and `samtools` to generate a pileup and call variants
    - creates an VCF file as the output
    - Uses `bcftools index` the VCF file
    - Extracts deletions using `bcftools view`
    - creates a new vcf file that contains deletions only

### Visualize in R

Script 5:
    - Use libraries `tidyverse` and `vcfR`
    - load vcf data into R as an object
    - plot the deletion positions as a heatmap or histogram

### Quarto/Markdown Documentation

This document will contain the detailed workflow for this project with a reproducible procedure. I currently have the workflow within VS Code as a markdown document.

## To-do List

1. Troubleshoot `seqkit.sh` script to obtain trimmed fasta files

1. Write the `fastqc.sh` script and run FastQC on the 3 fastq files within my `data/fastq` dir

1. Interpret the FastQC html file to determine whether the fastq files need to be trimmed
    
    - If they do not meet quality standards

