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
### Troubleshooting
I am getting an error on line 31 stating the following

```bash
# Starting script indel_position.sh
Mon Dec  1 12:21:07 PM EST 2025
# Input file:                      data/RF_043_SZAXPI009322-102.vcf.gz.snpeff.vcf.gz

# Output dir:                      results/

scripts/indel_position.sh: line 31: results/indel_position/chr3_indels.vcf: No such file or directory

```

I was able to confirm that my results and indel_position dirs were successfully created, so I will be troubleshooting this command in the terminal

I found that the issue was that my file was gunzipped instead of block gunzipped which is necessary for indexing and searching regionally (ex. `-r chr3`). I then found that I could use the following commands to unzip the file and then block gunzip the file.

```bash
# Renaming my file so it does not confuse the script by stating it is double compressed
mv data/RF_043_SZAXPI009322-102.vcf.gz.snpeff.vcf.gz  data/RF_043_SZAXPI009322-102.snpeff.vcf.gz
#Load module htslib
module load htslib/1.20
# Unzip my VCF file
gunzip -d data/RF_043_SZAXPI009322-102.snpeff.vcf.gz 
# Block gunzip my file
bgzip data/RF_043_SZAXPI009322-102.snpeff.vcf 
```

The next error I got specified that that it was unable to load an index so I used the following command to create an index.

```bash
tabix -p vcf data/RF_043_SZAXPI009322-102.snpeff.vcf.gz 

```
I was now able to get the command to work, so I will add the above commands to the setting up section of my README.md

### Found start and end position without the use of the script

When looking again at the supplemental information of the Kazachokova et. al. paper., I found the starting and ending coordinates of my region of interest.  Within the paper it states that Solcap_snp_33948 is the begining of the region and btr8 is the ending of the region.   

Solcap_snp_33948: SL2.50ch03:68765135
btr8: SL2.50ch03:68986544

## File preparation: seqkit

I want to learn more about `seqkit`, so I used the following command

```bash
apptainer exec "$seqkit" seqkit --help
```

The output was:

```bash
INFO:    Using cached SIF image
INFO:    gocryptfs not found, will not be able to use gocryptfs
SeqKit -- a cross-platform and ultrafast toolkit for FASTA/Q file manipulation

Version: 2.11.0

Author: Wei Shen <shenwei356@gmail.com>

Documents  : http://bioinf.shenwei.me/seqkit
Source code: https://github.com/shenwei356/seqkit
Please cite: https://doi.org/10.1002/imt2.191


Seqkit utilizes the pgzip (https://github.com/klauspost/pgzip) package to
read and write gzip file, and the outputted gzip file would be slighty
larger than files generated by GNU gzip.

Seqkit writes gzip files very fast, much faster than the multi-threaded pigz,
therefore there's no need to pipe the result to gzip/pigz.

Seqkit also supports reading and writing xz (.xz) and zstd (.zst) formats since v2.2.0.
Bzip2 format is supported since v2.4.0.

Compression level:
  format   range   default  comment
  gzip     1-9     5        https://github.com/klauspost/pgzip sets 5 as the default value.
  xz       NA      NA       https://github.com/ulikunitz/xz does not support.
  zstd     1-4     2        roughly equals to zstd 1, 3, 7, 11, respectively.
  bzip     1-9     6        https://github.com/dsnet/compress

Usage:
  seqkit [command] 

Commands for Basic Operation:
  faidx           create the FASTA index file and extract subsequences
  scat            real time recursive concatenation and streaming of fastx files
  seq             transform sequences (extract ID, filter by length, remove gaps, reverse complement...)
  sliding         extract subsequences in sliding windows
  stats           simple statistics of FASTA/Q files
  subseq          get subsequences by region/gtf/bed, including flanking sequences
  translate       translate DNA/RNA to protein sequence (supporting ambiguous bases)
  watch           monitoring and online histograms of sequence features

Commands for Format Conversion:
  convert         convert FASTQ quality encoding between Sanger, Solexa and Illumina
  fa2fq           retrieve corresponding FASTQ records by a FASTA file
  fq2fa           convert FASTQ to FASTA
  fx2tab          convert FASTA/Q to tabular format (and length, GC content, average quality...)
  tab2fx          convert tabular format to FASTA/Q format

Commands for Searching:
  amplicon        extract amplicon (or specific region around it) via primer(s)
  fish            look for short sequences in larger sequences using local alignment
  grep            search sequences by ID/name/sequence/sequence motifs, mismatch allowed
  locate          locate subsequences/motifs, mismatch allowed

Commands for Set Operation:
  common          find common/shared sequences of multiple files by id/name/sequence
  duplicate       duplicate sequences N times
  head            print the first N FASTA/Q records, or leading records whose total length >= L
  head-genome     print sequences of the first genome with common prefixes in name
  pair            match up paired-end reads from two fastq files
  range           print FASTA/Q records in a range (start:end)
  rmdup           remove duplicated sequences by ID/name/sequence
  sample          sample sequences by number or proportion
  split           split sequences into files by id/seq region/size/parts (mainly for FASTA)
  split2          split sequences into files by size/parts (FASTA, PE/SE FASTQ)

Commands for Edit:
  concat          concatenate sequences with the same ID from multiple files
  mutate          edit sequence (point mutation, insertion, deletion)
  rename          rename duplicated IDs
  replace         replace name/sequence by regular expression
  restart         reset start position for circular genome
  sana            sanitize broken single line FASTQ files

Commands for Ordering:
  shuffle         shuffle sequences
  sort            sort sequences by id/name/sequence/length

Commands for BAM Processing:
  bam             monitoring and online histograms of BAM record features

Commands for Miscellaneous:
  merge-slides    merge sliding windows generated from seqkit sliding
  sum             compute message digest for all sequences in FASTA/Q files

Additional Commands:
  genautocomplete generate shell autocompletion script (bash|zsh|fish|powershell)
  version         print version information and check for update

Flags:
      --alphabet-guess-seq-length int   length of sequence prefix of the first FASTA record based on
                                        which seqkit guesses the sequence type (0 for whole seq)
                                        (default 10000)
      --compress-level int              compression level for gzip, zstd, xz and bzip2. type "seqkit -h"
                                        for the range and default value for each format (default -1)
  -h, --help                            help for seqkit
      --id-ncbi                         FASTA head is NCBI-style, e.g. >gi|110645304|ref|NC_002516.2|
                                        Pseud...
      --id-regexp string                regular expression for parsing ID (default "^(\\S+)\\s?")
  -X, --infile-list string              file of input files list (one file per line), if given, they are
                                        appended to files from cli arguments
  -w, --line-width int                  line width when outputting FASTA format (0 for no wrap) (default 60)
  -o, --out-file string                 out file ("-" for stdout, suffix .gz for gzipped out) (default "-")
      --quiet                           be quiet and do not show extra information
  -t, --seq-type string                 sequence type (dna|rna|protein|unlimit|auto) (for auto, it
                                        automatically detect by the first sequence) (default "auto")
      --skip-file-check                 skip input file checking when given a file list if you believe
                                        these files do exist
  -j, --threads int                     number of CPUs. can also set with environment variable
                                        SEQKIT_THREADS) (default 1)

Use "seqkit [command] --help" for more information about a command.
```