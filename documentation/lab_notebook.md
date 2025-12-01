# Lab Notebook Documentation

## File Download

I am beginning this project by downloading a single fasta file from the Sol Genomics Network. I transfered this file into my `data/fasta` directory via filezilla.

## Seqkit 

Now, I want to use `seqkit` to ensure that I am looking in the right spot for the deletion. I used the following command to ensure that my file contained chromosome 3.

```bash
apptainer exec oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3 seqkit seq -n data/fasta/M82_MAS2.0.fasta.gz | head 
```

The output was:

```bash
INFO:    Using cached SIF image
INFO:    gocryptfs not found, will not be able to use gocryptfs
M82_MAS2.0ch01
M82_MAS2.0ch02
M82_MAS2.0ch03
M82_MAS2.0ch04
M82_MAS2.0ch05
M82_MAS2.0ch06
M82_MAS2.0ch07
M82_MAS2.0ch08
M82_MAS2.0ch09
M82_MAS2.0ch10

```
From this I can confirm that chromosome 3 is contained within this fasta file. I now want to see how long chromosome 3 is, so I used the following command

```bash


```


I am noticing a different from the GORKY paper and JL's dissertation. It appears that JL was useding ITAG 2.4 for GORKY-like-01 and GORKY-like-03 and ITAG 4.0 for GORKY and GORKY-like-02. I also am seeing that although the GORKY region may be around 69 MB on Heinz 1706 (I need to confirm this) the M82 sequence that I am looking at is not even 69MB in length. This is showing me that I should look to JBrowse for each sequence I download in order to make sure that I am capturing the right region for each reference genome.

The four gene I am looking for are 

|Gene Name      |Gene  ID               |
|---------------|-----------------------|
|GORKY          | Solyc03g120570        |
|GORKY-like-01  | Solyc03g120550        |
|GORKY-like-02  | Solyc03g120560        |
|GORKY-like-03  | Solyc03g120590        |


Now I am going to make a table specifying the exact region (including a 1.5kb buffer on each size) that contains GORKY and its homologs.

|Accession          | Genome Assembly Link | Region of Interest |
|---------------|-----------------------|----|
| Heinz 1706 SL2.5 |         |
| Heinz 1706 SL3.0  |         |
| Heinz 1706 SL4.0  | https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_000188115.5/  |
| EA03058           |         |
| M82               | https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_040143505.1/                      |
| OH8245            |                       |
| LA1416            |                       |
| Heinz 1706 SL5.0  |                       |

## Reworking the current planned procedure

As I was searching for my FASTA files, I could not find an available FASTA file for EA03058. EA03058 is the bitter accession that in theory should contain the GORKY deletion, so it is in turn the most important accession to have as data. 

I went through several different thought processes to decide how to proceed. 
    
    - First, I checked to see if I could identify any additional other bitter accesssion with increased alpha-tomatine that had a publicly available fasta file. From limited searching, I could not find any on Sol Genomics Network (SGN), NCBI, linked resouorces from SGN, or from general google searching,

    - Next, I began exploring if the available VCF files could be converted into FASTA files. From my research, I found that VCF files can be used to create a consensus FASTA file using the VCF file and a reference FASTA file. However, it does not appear to be a typical method used and I am uncomfortable with trying to use a created consensus FASAT file in place of a refereence genome FASTA file.

    - Another possibility is using the VCF files themselves for my deletion detection analysis. The deletion within the EA03058 accession was found in Kazachkova et al. using the 150 resequencing project on SGN, and this dataset was used in the previous student's dissertation. I could try to solely source my information from this dataset to create a more direct comparison to these two studies. 

    - Finally, the option I am most likely moving forward with is to use the fastq files that can be found on on the European Nucleotide Archive (ENA). On the 150 tomato resequencing project on page in SGN, there is a link to the same project information on ENA that contains fastq files for each accession within this project.  I am chosing to move forward with this option because I am more familiar with fastq files than any other file type.   

Currently I am going to move forward with only 5 of my proposed reference genomes. I am doing this to simplify the procedure, but I know I can add more files once I create a proof of concept.

1. All Heinz reference genomes
    - FASTA type files
    - Used to align reads
2. M82 
    - FASTA type file
    - Reference genome that is similar to the processing parent, OH8243
    - Used for aligning reads
3. EA03058
    - FASTQ files
    - Use reads that contain my region of interest

I am starting by downloading the the 3 available fastq files locally and then transferring the files into OSC FileZilla.  I also have access to VCF and BAM files for EA03058 which are both file types I expect to generate for this project. I plan to use thes files to confirm that I am on the right track.  

In Kazachkova et. al., it is stated that the region that contains GORKY and its homologs is Indel 3-5 (Indel 5 on chromosome 3). I will use the VCF file for EA03058 to extract the bp positioning on chromosome 3. I will then use SeqKit to cut the fasta and fastq file to only the section I am interested in. This will allow me to focus in only my region of interest.

## Working with Files: Data Preparation

The first thing I want to do is use my vcf file to identify indel 5 on chromosome 3.

To complete this, I will need the `bcftools` module. I will first check if the module exists within the installed software. 

I ran the following command:

```bash
module spider bcftools
```

The output was:

```bash
Lmod has detected the following error: 
Unable to find: "bcftools".

```

I then search "bcftools" on seqera and I found a bioconda container. I want to learn more about the container, so after I save the container as a constant. I ran the following command:

```bash
apptainer exec "$bcftools" bcftools --help
```
The output was

```bash
INFO:    Downloading oras image
107.2MiB / 107.2MiB [==========================================] 100 % 29.5 MiB/s 0s
INFO:    gocryptfs not found, will not be able to use gocryptfs

Program: bcftools (Tools for variant calling and manipulating VCFs and BCFs)
License: GNU GPLv3+, due to use of the GNU Scientific Library
Version: 1.22 (using htslib 1.22)

Usage:   bcftools [--version|--version-only] [--help] <command> <argument>

Commands:

 -- Indexing
    index        index VCF/BCF files

 -- VCF/BCF manipulation
    annotate     annotate and edit VCF/BCF files
    concat       concatenate VCF/BCF files from the same set of samples
    convert      convert VCF/BCF files to different formats and back
    head         view VCF/BCF file headers
    isec         intersections of VCF/BCF files
    merge        merge VCF/BCF files files from non-overlapping sample sets
    norm         left-align and normalize indels
    plugin       user-defined plugins
    query        transform VCF/BCF into user-defined formats
    reheader     modify VCF/BCF header, change sample names
    sort         sort VCF/BCF file
    view         VCF/BCF conversion, view, subset and filter VCF/BCF files

 -- VCF/BCF analysis
    call         SNP/indel calling
    consensus    create consensus sequence by applying VCF variants
    cnv          HMM CNV calling
    csq          call variation consequences
    filter       filter VCF/BCF files using fixed thresholds
    gtcheck      check sample concordance, detect sample swaps and contamination
    mpileup      multi-way pileup producing genotype likelihoods
    polysomy     detect number of chromosomal copies
    roh          identify runs of autozygosity (HMM)
    stats        produce VCF/BCF stats

 -- Plugins (collection of programs for calling, file manipulation & analysis)
    41 plugins available, run "bcftools plugin -lv" to see a complete list

 Most commands accept VCF, bgzipped VCF, and BCF with the file type detected
 automatically even when streaming from a pipe. Indexed VCF and BCF will work
 in all situations. Un-indexed VCF and BCF and streams will work in most but
 not all situations.

```

