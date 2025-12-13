# GORKY Final Project Protocol

## Project Background 

GORKY is a gene found in tomatoes that encodes a NPF (nitrate peptide family) transporter protein involved in the biosynthesis pathway of steroidal glycoalkaloids. The transporter is hypothesized to transport alpha-tomatine from the vacuole to the cytosol, where it is then converted to lycoperoside F/G/esculeoside A (FGA). This deletion spans the 612 bp and is located at the end of the last exon of the protein and the 3' UTR region. The presence of this deletion results in the loss of function pof the transporter protein. The LOF of the GORKY gene is thought to be responsible for the accumulation of alpha-tomatine in ripe tomatoes. 

Our lab is interested in this gene because of the potential health benefits of alpha-tomatine. There has been several studies that have provided strong evidene for potential health benefits linked to alpha-tomatine consumption both in-vitro and in-vivo. In order to study the health benefits of alpha-tomatine consumption through whole fruit intervention, our lab has bred a high-alpha tomaine tomato. We believe that the mechanism in which our tomatoes accumulate high levels of alpha-tomaine is through the GORKY deletion, but we have not found this deletion in the high alpha tomatine tomatoes we study or the high alpha tomatine tomatoes with the Kazachkova et. al, 2021 paper. 

 A previous PhD student aligned seven genomes, including some are expected to have the GORKY deletion, but did not find the deletion in any of them. 

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

This script will locate the chromosome, type of strand (+/-), start position, and end position of an input primer set.  The inputs to this script include: reference genomes, forward primer sequence, reverse primer sequence, and output directory. The output of this script is a 2 tsv files per reference genome that provides the location and the forward and reverse primers.

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

The purpose of this script is to extract a gff3 file from the gbff files. The following code block will loop over each gbff file within the `gbff` subdirectory and output a gff3 file into the `gff3` subdirectory.

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
  
This script will convert my trimmed gff file to a gff3 file type.

```bash
# Save the new trimmed gff file as a variable

gff_chr3=data/gff/trimmed/Heinz_1706.3_SL2.50_genomic.gff_NC_015440.2.gff

# Run the file conversion script

bash scripts/gff_to_gff3.sh "$gff_chr3"
```


## File Preparation: FastQC

This script will run FastQC on all 4 of the FASTQ files within my `fastq` directory by looping over each file within the directory. Each file will be represented by a separate batch job.

```bash
for fastq_file in data/fastq/*; do
    sbatch scripts/fastqc.sh "$fastq_file" "$outdir"
done
```

## Align Reads

This scripts will take the single chromosome reference genome file and paired fastq reads as the input, and align those reads to the reference genome. It will create BAM files as it's output. Before running the `align.sh` script, we will need to save the new corrected files under input variable names

I also will save our full chromosome fasta files as variables to align those sequences


You might not need the following code chunk

```bash
heinz_3_chr_fasta=data/fasta/fasta_chromosome/Heinz1706.3_SL2.50_NC_015440.2.fna
heinz_4_chr_fasta=data/fasta/fasta_chromosome/Heinz1706_SL4.0_CM001066.4.fna
m82_chr_fasta=data/fasta/fasta_chromosome/M82_CM079137.1.fna
```


The following commands will run the scripts as a slurm batch job:

This code chunk is for running LA1416 reads

```bash
for ref_genome in data/fasta/fasta_chromosome/*.fna; do
      #echo "# Running analysis on: $ref_genome"
    sbatch scripts/align_LA.sh "$ref_genome" "$fastq_LA_1" "$fastq_LA_2" "$outdir"
done

```


The following chunk will run the `align.sh` script as a slurm batch job over each of full chromosome fasta files for EA03058 files:

```bash
for ref_genome in data/fasta/region/*.fna; do
    #echo "# Running analysis on: $ref_genome"
    sbatch scripts/align.sh "$ref_genome" "$fastq_EA_1" "$fastq_EA_2" "$outdir"
done

```

## MultiQC to Gauge the Quality of my Read Alignments

```bash
sbatch scripts/multiqc.sh "$outdir"aligned/mapped+sorted "$outdir"
```

## Create VCF files for the EA03058 BAM files to import into JBrowse

This script takes a reference genome, a mapped and sorted BAM file, and an output directory as inputs and will output two vcf files. On file will be filtered to only contain deletions, the other file will contain both insertions and deletions.

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

