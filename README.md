# GORKY Final Project Protocol

## Project Background 

GORKY is a gene found in tomatoes that encodes a NPF (nitrate peptide family) transporter protein involved in the biosynthesis pathway of steroidal glycoalkaloids. This transporter protein is hypothesized to transport alpha-tomatine from the vacuole to the cytosol, where it is then converted to lycoperoside F/G/esculeoside A (FGA). For this project, I want to investigate a deletion within this gene that spans 612 bp and is located at the end of the last exon of the protein and the 3' UTR region. The presence of this deletion results in the loss of function of the transporter protein. The LOF of the GORKY gene is thought to be responsible for the accumulation of alpha-tomatine in ripe tomatoes. 

Our lab is interested in this gene deletion because of the potential health benefits of alpha-tomatine. There has been several studies that have provided strong evidence for potential health benefits linked to alpha-tomatine consumption both in-vitro and in-vivo. In order to study the health benefits of alpha-tomatine consumption through whole fruit intervention, our lab has bred a high-alpha tomaine tomato. We believe that the mechanism in which our tomatoes accumulate high levels of alpha-tomaine is through the GORKY deletion, but we have not found this deletion in the high alpha tomatine tomatoes we study or the high alpha tomatine tomatoes with the Kazachkova et. al, 2021 paper. 

A previous PhD student aligned seven genomes, including some are expected to have the GORKY deletion, but did not find the deletion in any of them. I want to try to find the previous genomes he used, and investigate the primer region reported by Kazachkova et. al. to scan for a deletion of the same length and location. 

## Goal:

For this project, I want to use the same genomic data used in Kazachkova et. al. to see if I can find the GORKY deletion in the location in which they reported it. To achieve this goal, I will gather the data directly from the resources linked in the paper.

## Setting up

Prior to beginning this procedure, ensure that the working directory is set to `fp_gorky/`.

Before beginning the file download portion of this protocol, I must make a `data` and `results` directory

```bash
mkdir -p  data
mkdir -p results
```

### Download files and transfer them to the `data` directory

The *EA03058* FASTQ files are sourced from the **150 tomato resequencing project** and will be downloaded through the following code block

```bash
# Make fastq subdirectory

mkdir -p data/fastq

# EA03058 FASTQ R1 file

wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR418/ERR418079/ERR418079_1.fastq.gz

# Move file to data dir

mv ERR418079_1.fastq.gz fp_gorky/data/fastq/ERR418079_EA_1.fastq.gz

# EA03058 FASTQ R2 file

wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR418/ERR418079/ERR418079_2.fastq.gz

# Move and rename file to data dir

mv ERR418079_2.fastq.gz data/fastq/ERR418079_EA_2.fastq.gz
```

The *LA1416* FASTQ files are sourced from the **NCBI SRA**. To downlaod these paired-end FASTQ files, I will need to run the `sra-download.sh` script.

```bash
bash scripts/sra-download.sh
```

All the reference FASTA files are sourced from **NCBI**. I will use `wget` and the **ftp** links page to download these files

```bash
# Make fasta subdirectory

mkdir -p data/fasta

# Download Heinz SL4.0

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/188/115/GCA_000188115.5_SL4.0/GCA_000188115.5_SL4.0_genomic.fna.gz 

# Move and rename the ref genome

mv GCA_000188115.5_SL4.0_genomic.fna.gz data/fasta/Heinz1706_SL4.0_genomic.fna.gz

# Download Heinz 1706 SL2.50

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/188/115/GCF_000188115.3_SL2.50/GCF_000188115.3_SL2.50_genomic.fna.gz 

# Move and rename the ref genome

 mv GCF_000188115.3_SL2.50_genomic.fna.gz data/fasta/Heinz1706.3_SL2.50_genomic.fna.gz

# Download M82 Reference Genome

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/040/143/505/GCA_040143505.1_ASM4014350v1/GCA_040143505.1_ASM4014350v1_genomic.fna.gz

# Move and rename the ref genome

mv GCA_040143505.1_ASM4014350v1_genomic.fna.gz data/fasta/M82_genomic.fna
```

Now, download the corresponding gff and gbff files from the same **ftp** links page on **NCBI** to download the reference genome FASTA files.

```bash
# Make gbff and gff subdirectories

mkdir -p data/gff
mkdir -p data/gbff

# Download Heinz 1706 SL4.0 gbff

wget -nc https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/188/115/GCA_000188115.5_SL4.0/GCA_000188115.5_SL4.0_genomic.gbff.gz 

# Move and rename the gbff file

mv GCA_000188115.5_SL4.0_genomic.gbff.gz  
 data/gbff/Heinz1706_SL4.0_genomic.gbff.gz

# Unzip gbff file

gunzip data/gbff/Heinz1706_SL4.0_genomic.gbff.gz

# Download the Heinz1706 SL2.50 gff

wget -nc https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/188/115/GCF_000188115.3_SL2.50/GCF_000188115.3_SL2.50_genomic.gff.gz

# Move and rename gff file

mv GCF_000188115.3_SL2.50_genomic.gff.gz data/gff/Heinz1706.3_SL2.50_genomic.gff.gz

# Download the M82 gbff

wget -nc https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/040/143/505/GCA_040143505.1_ASM4014350v1/GCA_040143505.1_ASM4014350v1_genomic.gbff.gz

# Move and rename the M82 gbff file

mv GCA_040143505.1_ASM4014350v1_genomic.gbff.gz data/gbff/M82_genomic.gbff.gz

# Unzip gbff file 

gunzip data/gbff/M82_genomic.gbff.gz
```

### Set up files paths

```bash
#Inputs

ref_heinz_3=data/fasta/Heinz1706.3_SL2.50_genomic.fna
ref_heinz_4=data/fasta/Heinz1706_SL4.0_genomic.fna
ref_m82=data/fasta/M82_genomic.fna 
fastq_EA_1=data/fastq/ERR418079_EA_1.fastq.gz
fastq_EA_2=data/fastq/ERR418079_EA_2.fastq.gz
fastq_LA_1=data/fastq/ERR11752506_1.fastq.gz
fastq_LA_2=data/fastq/ERR11752506_2.fastq.gz
primer_seq_1="CTCATAATACCAAGCTGTTTAAATG"
primer_seq_2="GAGTTTGTTAGATATTTGCATCTATG"
heinz_2_gff=data/gff/Heinz_1706.3_SL2.50_genomic.gff
heinz_4_gbff=data/gbff/Heinz_1706_SL4.0_genomic.gbff.gz
m82_gbff=data/gbff/M82_genomic.gbff.gz

# Output

outdir=results/
```

## File Preparation:  Find the primer positions within each reference genome

This script will locate the chromosome, type of strand (+/-), start position, and end position of an input primer set.  The inputs to this script include: reference genomes, forward primer sequence, reverse primer sequence, and output directory. The output of this script is a 2 tsv files per reference genome that provides the location and the forward and reverse primers. This script will provide both the name of the chromosome of interest and the unique primer positions within each reference genome.

```bash
for ref_genome in data/fasta/*.fna; do
    sbatch scripts/primer_position.sh "$ref_genome" "$primer_seq_1" "$primer_seq_2" "$outdir"
done
```

## File Preparation: Creating a fasta file that only contains one chromosome

This script will accept both reference genome fasta files and an output directory as inputs and will output fasta files that only contain the chromosome in which the primers were located.

Before running the script, the names of the chromosome we are interested in must be saved as input variables

```bash
heinz_2_chr_name=$(awk 'NR==2 {print $1}' results/primer_region/Heinz1706.2_SL2.50_genomic.fna_forward.tsv)
heinz_3_chr_name=$(awk 'NR==2 {print $1}' results/primer_region/Heinz1706.3_SL2.50_genomic.fna_forward.tsv)
heinz_4_chr_name=$(awk 'NR==2 {print $1}' results/primer_region/Heinz1706_SL4.0_genomic.fna_forward.tsv)
m82_chr_name=$(awk 'NR==2 {print $1}' results/primer_region/M82_genomic.fna_forward.tsv)
```

Now I can run my desired script:

```bash
bash scripts/seqkit_chr.sh "$ref_heinz_2" "$ref_heinz_3" "$ref_heinz_4" "$ref_m82" "$heinz_2_chr_name" "$heinz_3_chr_name" "$heinz_4_chr_name" "$m82_chr_name" data/fasta/
```
## File Preparation: Extracting a gff3 file from a gbff file

The purpose of this script is to extract a gff3 file from the gbff files. This is important to be able to the annotation file as a track on JBrowse.The following code block will loop over each gbff file within the `gbff` subdirectory and output a gff3 file into the `gff3` subdirectory.

```bash
for gbff_file in data/gbff/*; do
    #echo " # Running analysis on: $gbff_file"
    bash scripts/gbff_to_gff.sh "$gbff_file"
done
```

## File Preparation: Creating smaller gff

This script will accept an input gff files and the name of its corresponding chromosome, and output a trimmed gff that only contains the chromosome of interest. 

```bash
bash scripts/gff_trim_chr.sh "$heinz_2_gff" "$heinz_3_chr_name"
```

## File Preparation: Creating a GFF file that only contains our chromosome of interest
  
This script will convert my trimmed gff file to a gff3 file type. This is necessary in order to be able to add the annotation as a track on JBrowse.

```bash
# Save the new trimmed gff file as a variable

gff_chr3=data/gff/trimmed/Heinz_1706.3_SL2.50_genomic.gff_NC_015440.2.gff

# Run the file conversion script

bash scripts/gff_to_gff3.sh "$gff_chr3"
```


## File Preparation: FastQC

This script will run FastQC on all 4 of the FASTQ files within my `fastq` directory by looping over each file within the directory. Each file will be represented by a separate batch job. This script allows me to gauge the quality of the reads prior to alignment. If the read quality is low, I will have to write a new script that can trim low quality information from the FASTQ files where possible.

```bash
for fastq_file in data/fastq/*; do
    sbatch scripts/fastqc.sh "$fastq_file" "$outdir"
done
```
Each of the FASTQ files were of high quality, and do not require quality trimming.

## Align Reads

This scripts will take the single chromosome reference genome file and paired fastq reads as the input, and align those reads to the reference genome. It will create a mapped and sorted BAM and BAM index files as it's output. This script is crucial to this procedure as it creates the main files necessary for scanning for a deletion within JBrowse. Each read has its own script for alignment and the following commands will run the scripts as a slurm batch job:

This code chunk is for running the `align_LA.sh` script to align the *LA1416* reads

```bash
for ref_genome in data/fasta/fasta_chromosome/*.fna; do
      #echo "# Running analysis on: $ref_genome"
    sbatch scripts/align_LA.sh "$ref_genome" "$fastq_LA_1" "$fastq_LA_2" "$outdir"
done
```

The following chunk will run the `align.sh` script as a slurm batch job over each of full chromosome fasta files for *EA03058* files:

```bash
for ref_genome in data/fasta/region/*.fna; do
    #echo "# Running analysis on: $ref_genome"
    sbatch scripts/align.sh "$ref_genome" "$fastq_EA_1" "$fastq_EA_2" "$outdir"
done
```

## MultiQC to Gauge the Quality of my Read Alignments

This script will accept the a folder of mapped and sorted BAM files to run MultiQC on all of them as a whole. The output of this script will be in its own `multiqc` subdirectory. This script allows me to gauge the quality of the alignment, so I can add extra filtering if I deem it necessary.

```bash
sbatch scripts/multiqc.sh "$outdir"aligned/mapped+sorted "$outdir"
```

The quality of the alignments looked good overall. The main thing I noted was that there were around 10-20% of the aligned reads had an MQ = 0. This indicates to me that there are ambigous reads within this data set that may mismap or map to multiple places. In the future, I may want to filter our these lower quality reads so I can feel more confident in my ability to draw confident conclusions from my data.

## Create VCF files for the EA03058 BAM files to import into JBrowse

This script takes a reference genome, a mapped and sorted BAM file, and an output directory as inputs and will output a VCF file and its corresponding index. This script is important to be able to add a VCF track to further analyze the primer region.

```bash
# Save the trimmed reference genome files as variables

heinz_3_chr_fasta=data/fasta/fasta_chromosome/Heinz1706.3_SL2.50_NC_015440.2.fna
heinz_4_chr_fasta=data/fasta/fasta_chromosome/Heinz1706_SL4.0_CM001066.4.fna
m82_chr_fasta=data/fasta/fasta_chromosome/M82_CM079137.1.fna

# Save the mapped and sorted BAM files as variables

m82_EA_bam=results/aligned/mapped+sorted/M82_CM079137.1.fna.mapped.sorted.bam
heinz_4_EA_bam=results/aligned/mapped+sorted/Heinz1706_SL4.0_CM001066.4.fna.mapped.sorted.bam
heinz_2_EA_bam=results/aligned/mapped+sorted/Heinz1706.3_SL2.50_NC_015440.2.fna.mapped.sorted.bam

# Run the vcf script on the Heinz 1706 SL2.50 files

sbatch scripts/vcf.sh "$heinz_3_chr_fasta" "$heinz_2_EA_bam" "$outdir"

# Run the vcf script on the Heinz 1706 SL4.0 files

sbatch scripts/vcf.sh "$heinz_4_chr_fasta" "$heinz_4_EA_bam" "$outdir"

# Run the vcf script on the M82 files

sbatch scripts/vcf.sh "$m82_chr_fasta" "$m82_EA_bam" "$outdir"
```

## Alignment Comparison in JBrowse

1. Use FileZilla to transfer the following files into your computer's files for each reference genome:
    - Reference genome FASTA and FASTA index file
    - Mapped and sorted BAM file for *EA03058* alignment and corresponding index file
    - Mapped and sorted BAM file for *LA 1416* alignment and corresponding index file
    - VCF file for *EA03058* alignment with corresponding index file
    - Trimmed gff3 file and corresponding index (where available)
1. Open JBrowse on local computer
1. Click the **OPEN NEW GENOME** button under the **Launch new session** heading
1. Add the FASTA file and the corresponding index under the appropriate sections
1. Name the new assembly with the name and version of the reference genome with other identifying information such as the aligned genomes
1. Click the **FILE** tab in the upper left hand corner and then click **Open track...**
1. Add the *LA 1416* BAM file with its corresponding index file
1. Open another track to add the *EA03058* BAM file and its corresponding index as an additional track
1. Open another track to add the *EA03058* VCF file and its corresponding index
Open a file track to add the GFF3 annotation file and its correpsonding index
1. Look at the forward and reverse primer tsv file that corresponds to the currently opened reference genome under `results/primer_region`
1. Bookmark the exact primer positions based on the start and end position provided for each primer
1. Analyze the area found between these primers

## Citations:

Kazachkova, Y., Zemach, I., Panda, S., Bocobza, S., Vainer, A., Rogachev, I., Dong, Y., Veres, D., Kanstrup, C., Lambertz, S. K., Crocoll, C., Hu, Y., Shani, E., Michaeli, S., Hassan, H., Zamir, D., & Aharoni, A. (2021). The GORKY glycoalkaloid transporter is indispensable for preventing tomato bitterness. Nature Plants, 7(4), 468-480. https://doi.org/10.1038/s41477-021-00865-6

Morton, M., Fiene, G., Ahmed, H. I., Rey, E., Abrouk, M., Angel, Y., Johansen, K., Saber, N. O., Malbeteau, Y., Al-Mashharawi, S., Ziliani, M. G., Aragon, B., Oakey, H., Berger, B., Brien, C., Krattinger, S. G., A. Mousa, M. A., McCabe, M. F., Negrão, S., . . .  Julkowska, M. M. (2024). Deciphering salt stress responses in Solanum pimpinellifolium through high-throughput phenotyping. The Plant Journal, 119(5), 2514-2537. https://doi.org/10.1111/tpj.16894