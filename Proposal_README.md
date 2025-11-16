# Final Project Proposal: Tomato Genome Alignment for GORKY Deletion

## Project Overivew

This project aims to align multiple FastQ files from a variety of tomato reference genomes that contain the GORKY deletion. In the following sections, I will outline more details about the background of the project, the objectives, current candidates for reference genomes, and the proposed methodology for project completion.

## Background

GORKY is a gene found in tomatoes that encodes a transporter protein involved in the biosynthesis pathway of glycoalkaloids. The transporter is hypothesized to transport alpha-tomatine from the vacuole to the cytosol, where it is then converted to lycoperoside F/G/esculeoside A (FGA). The deletion of the GORKY gene is thought to be responsible for the accumulation of alpha-tomatine in ripe tomatoes, which has the potential to provide health benefits to the consumer, but also may lead to increased bitterness and other noted off-flavors. 

This gene deletion is relevant to our lab's research on tomato steroidal glycoalkaloids (tSGAs) because we have not found this deletion in the high alpha-tomatine accession that we have previously bred.  A previous PhD student aligned seven genomes, including some that should have the GORKY deletion, but did not find the deletion in any of them. We believe that this deletion is reposnible for the high alpha-tomatine content in our tomato line, and this alignment would help my lab better understand why our tomato line has high alpha-tomatine content.

## Proposed Reference Genomes

### What portion of the geonome are we interested in?

The GORKY deletion is a 612bp in length and located on the southern arm of chromosome 3. I will focus on the same approximately 34kb region that was examined in the previous student's analysis. This region begins at approximately 69mb on chromosome 3 and contains the GORKY gene and 3 GORKY-like homologs.  He also included 1.5kb of buffer sequence on either side of the GORKY gene.

### Candidate Reference Genomes:

The following seven reference genomes were previously aligned by the former student who conducted a similar analysis. I plan to use these same genomes for my analysis:

1. Heinz 1706 SL2.5
2. Heinz 1706 SL3.0
3. Heinz 1706 SL4.0
4. EA03058
    - Expected to have GORKY deletion
    - Used instead of LA2213 (donor parent) because this genome was unavailable at the time of assembly
5. M82
    - similar to processing type donor parent, OH8243
6. OH8245
    - similar to processing type donor parent, OH8243
7. LA1416

I also plan to include some additional reference genomes that either are recently available or that may be relevant to my future breeeding work:

1. Heinz 1706 SL5.0
    - Newest version of the Heinz reference genome
2. TBD high FGA tomato breed (1-2 reference genomes)
    - this should contain the GORKY gene
    - releveant to a future effort of breeding high FGA tomatoes
    - Yet to be determined from available data, but should be identified soon.
3. LA2213  
    - I haven't searched much, but if I can find this sequence, it would be very helpful as this is the donor parent for our high-alpha tomatine tomatoes.
    - If I cannot find this reference genome, I will then add another reference genome that should also display the GORKY deletion


### Expected Input File Types

I am expecting to have several reference genome files (assembly and annotation for each). FASTA files for each accession should be suffcient for detection of the GORKY deletion, but I may want to find GTF files if I choose to visualize these the genomic comparison in a genome browser. 

## Proposed Procedure

This procedure was written with the help of Microsoft Copilot. Since I am inexperienced procedure, I used a series of prompts to learn the basic steps of alignment, and prompted the AI to conduct a series of comparison to decide which tools to use to complete these steps.

1. Use `seqkit` to isolate my region of interest from the full sequence files.
    - My region of interest is on chromosome 3 and begins at approximately 69mb and is 34kb in length
    - Submitted as a slurm batch job from my procedural `README.md`
    - this script will use a loop to cycle through each tomato genome and extract the exact region of interest from each.

1. Concatenate all the FASTA files into a single file containing all the sequences for alignment

1. Use `MAFFT` for multiple sequence alignment 
    - Copilot suggested I use the following options when using `mafft` as a command. I am planning on investigating these options by using the `--help` option
        - `--thread 8` : specify my CPU
        - `--maxiterate 1000` : used to improve accurraccy for iterative refinement.
        - `--localpair` : use local alignment

1. Use `seqkit` again to format the alignment
    - Suggested command is as follow

    ```bash
    seqkit stats aligned_sequences.fasta
    ```

1. Use R to visualize and analyze the cleaned up mafft output

    - Load necessary packages
        - `ape`, `Biostrings`, `DECIPHER`, `tidyverse`
    - Read and convert alignment
        - Suggested code
             ```bash
            alignment <- readDNAStringSet("aligned_sequences.fasta")
            alignment_matrix <- as.matrix(alignment)
            ```
    - Create a heatmap of deletions across accessions

1. Document workflow in Quarto
    - I will have more thoughts on this once I watch the Quarto lecture

### Potential Additions

I believe that this procedure will be suffcient to determine whether or not the GORKY deletion is present in any of the reference genomes I have proposed. However, I may want to add some additional components to this project if it will improve my ability to understand the output of my code and if time is permitting. 

- I may want to use BLAST to map the deletions back to the genome coordinates

- Looking ahead to future lectures, I might want to automate the workflow by creating a pipeline for future datasets

- I could find GTF files for each reference genome to use JBrowse to overlay the gene models

## Future Steps

I began this proposal confused about the differences in the handeling of FASTA and FastQ files, so I wrote a simple procedure of aligning FastQ files to a reference genome similar to that of what we completed in exercise 4. 

I believe that this procedure could be useful if we choose to sequence the high alpha tomatine tomato that our lab previously bred. If we sequence this new accession or LA2213 (high alpha-tomatine parent) we can use this procedure to align the fastq files with one reference genome with the GORKY deletion and one reference genome without the GORKY deletion.

1. Download the reference genomes annotations (GTF).

2. Download the reference genome assembly FASTA files and the FastQ raw sequence files

3. Unzip all files

4. Read QC reports using the FASTQC
    - First script
    - will run as a slurm batch job for each file
    - Produces zipped files and html files for each read

5. Get FastQC summaries with MultiQC
    - Second script
    - produces several txt files that are used to create a comprehensive html report

6. Quality trim files with TrimGalore
    
    - third script
    - produces a zipped, trimmed fastq file, a txt trimming report, a gunzipped fastq file, and a hmtl fastqc report   

7. Create a reference genome index with STAR

    - fourth script
    - the FASTA and annotation files will be the input for this script
    - the genome index dir is used for the input of the STAR alignment

8. Align the trimmed reads to the reference genome index with STAR

    - fifth script
    - produces BAM files
        - these will be important for the downstream analysis
    - also produces two `.out` files that are used

9. Filter for GORKY deletion 
    
    - this has not been covered in class and will take some digging to learn how to complete this.
    -sixth script?

## Current Points of Confusion

Since these topics are still quite new to me, I want to spend some time trying to understand the tools I will be using. Particularly, I want to focus on `seqkit`, `mafft`, and `Quarto`. 

The part of this process I am the most confused on currently is how I will locate my desired reference genomes. NCBI and the Sol Genomics Network, and the 150 tomato genome ReSequencing project.

I also am unsure if the R visualization will be suffcient to visualize the output from the `mafft` command, so I may want to use another tool such as BLAST or JBrowse to visualize these sequences in a way that I have seen before.

A previous student in the lab found a QTL for high alpha-tomatine content that contains the GORKY gene. I would be interested in comparing the entire previously defined QTL region to see if there are any other differences between the genomes that may be contributing to high alpha-tomatine content. I am unsure how feasible it will be to compare the entire QTL because it starts before GORKY continues until the end of the chromosome. Given that I will be comparing very different tomatoes, I would understand if there are several differences between these sequences that are entirely unrelated to high-alpha tomatine content.


## Git Repo Problem Notes

My files are not tracking at all in my git repo and I have spent quite a long time troubleshooting this issue to no avail. I am going to try to remove my git repo and create a new one, but I am attaching a screenshot below with all of my current commits. None of my files saved to the git remote repo, so I think starting a new git repo may be the easiest way to fix this problem.

Current commits and messages found in `imgs` directory named `previousgitlog.png`.
