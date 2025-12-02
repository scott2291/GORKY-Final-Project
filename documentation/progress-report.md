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

Script 4: `align.sh`
    - uses `bwa` and `samtools` to algin the paired-end reads to the reference genomes
        - `bwa` for the alignment
        - `samtools` for converting the SAM file to a BAM file
        -`samtools` to sort the BAM file for future analysis

### Call Variants and Filter for Deletions

Script 4: `call_and_filter.sh`
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
    
    - If they do not meet quality standards:
        - Write `trimgalore.sh` script
        - Use trimmed fastq reads for the remaining downstream analysis

1. Write the `align.sh` script to align my reads to both of my reference genomes


1. Write and troubleshoot the `call_and_filter.sh` script to call the variants within my region of interest, and extract only the deletions present within this region.

1. Check the length of the deletions that you found to verify that one of the deletions is 612bp (the reported length of the GORKY deletion)

    - If no 612bp deletion is present, maybe try comparing the VCF and BAM files that are available from the same database that I sourced the fastq files from (ENA).

1. Use R and Quarto to create a heatmap and a histogram of the deletions

    - Decide which I like better and use that plot

## Feedback

My `indel_position.sh` script is no longer needed for my workflow because I was able to source the information from my the supplemental information within the Kazachkova et. al. paper. I have not removed this script because I spent a signifincant amount of time on it, and it should help meet the first requirement of this assignment along with the `seqkit.sh` script.

If you want to see any of the troubleshooting that I have underwent so far, I have detailed that information in the `lab_notebook.md` file.

What I want to get feedback on the most, is if this workflow and these functions make sense for what I am trying to achieve. I also am curious if you think it is a good idea to use MultiQC after alignment.  

