# GORKY Final Project Protocol

## Setting up

1. Download files and transfer via FileZilla

Fastq files from the 150 tomato resequencing project

```bash
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR418/ERR418079/ERR418079_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR418/ERR418079/ERR418079_2.fastq.gz

```
Fasta files from NCBI

```
# this is not working yet
# This works but it is putting the files in the working dir instead of where it is specified
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/188/115/GCA_000188115.5_SL4.0/GCA_000188115.5_SL4.0_genomic.fna.gz > data/fasta/GCA_000188115.5_SL4.0.fna.gz
```


1. Unzip reference genome files

```bash
gunzip -v data/

```

1. Set up files paths

```bash
#Inputs

ref_heinz_2=data/fasta/Heinz1706.2_SL2.50_genomic.fna
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

# Output

outdir=results/

```

## File Preparation:  Find the primer positions within each reference genome

This script will locate the chromosome, type of strand (+/-), start position, and end position of an input primer set.  The inputs to this script include: reference genome (fasta), forward primer sequence, reverse primer sequence, and output directory. The output of this script is a 2 tsv files per reference genome that provides the location and the forward and reverse primers.

```bash
for ref_genome in data/fasta/*.fna; do
    #echo "# Running analysis on $ref_genome"
    sbatch scripts/primer_position.sh "$ref_genome" "$primer_seq_1" "$primer_seq_2" "$outdir"
done

```

## File Preparation: Creating smaller fasta 

This script will accept both reference genome fasta files and an output directory as inputs and will output fasta files that only contain the regions I am interested in.

```bash
bash scripts/seqkit.sh "$ref_heinz_2" "$ref_heinz_3" "$ref_m82" data/fasta/
```

## File Preparation: Creating a fasta file that only contains one chromosome

This script will accept both reference genome fasta files and an output directory as inputs and will output fasta files that only contain the chromosome that the inputed primers were located on

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


## File Preparation: Creating smaller gff

This script will accept both the input and the output gff files, and output a trimmed gff that only contains the region of interest.

```bash
bash scripts/gff_trim.sh data/gff/genomic.gff data/gff/Heinz1706.3_trimmed.gff
```

```bash
bash scripts/gff_trim_chr.sh "$heinz_2_gff" "$heinz_3_chr_name"
```

## File Preparation: Creating a GFF file that only contains our chromosome of interest
  
This script will convert my trimmed gff file to a gff3 file type.

```bash
gff_chr3=data/gff/trimmed/Heinz_1706.3_SL2.50_genomic.gff_NC_015440.2.gff
bash scripts/gff_to_gff3.sh "$gff_chr3"

```



## File Preparation: FastQC

This script will run FastQC on all three of my files within my fastq directory by looping over each file within the directory. Each file will represent a separate batch job.

```bash
for fastq_file in data/fastq/*; do
    #echo "# Running analysis on $fastq_file"
    sbatch scripts/fastqc.sh "$fastq_file" "$outdir"
done
```

## Align Reads

This scripts will take a corrected reference genome file and paired fastq reads as input, and align those reads to the reference genome. It will create BAM files as it's output. Before running the `align.sh` script, we will need to save the new corrected files under input variable names

I also will save our full chromosome fasta files as variables to align those sequences


You might not need the following code chunk

```bash
heinz_2_chr_fasta=data/fasta/fasta_chromosome/Heinz1706.2_SL2.50_CM001066.2.fna
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

## Call Variants and Filter for Deletions

This script takes a reference genome, a mapped and sorted BAM file, and an output directory as inputs and will output two vcf files. On file will be filtered to only contain deletions, the other file will contain both insertions and deletions.

```bash
heinz_ms_bam_2=results/aligned/Heinz1706.2_SL2.50_corrected.fna.mapped.sorted.bam
heinz_ms_bam_3=results/aligned/Heinz1706.3_SL2.50_corrected.fna.mapped.sorted.bam

bash scripts/call_and_filter.sh "$heinz_corrected_3" "$heinz_ms_bam_3" "$outdir"

```

