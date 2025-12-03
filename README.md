# GORKY Final Project Protocol

## Setting up

1. Download files and transfer via FileZilla

1. Unzip reference genome files

```bash
gunzip -v data/

```

1. Set up files paths

```bash
#Inputs

ref_heinz_2=data/fasta/Heinz1706.2_SL2.50_genomic.fna
ref_heinz_3=data/fasta/Heinz1706.3_SL2.50_genomic.fna
ref_m82=data/fasta/M82_genomic.fna 
primer_seq_1=: "CTCATAATACCAAGCTGTTTAAATG"
primer_seq_2="GAGTTTGTTAGATATTTGCATCTATG"

# Output

outdir=results/

```

## File Preparation: Creating smaller fasta 

This script will accept both reference genome fasta files and an output directory as inputs and will output fasta files that only contain the regions I am interested in.

```bash
bash scripts/seqkit.sh "$ref_heinz_2" "$ref_heinz_3" "$ref_m82" data/fasta/
```

## File Preparation: Creating smaller gff

This script will accept both the input and the output gff files, and output a trimmed gff that only contains the region of interest.

```bash
bash scripts/gff_trim.sh data/gff/genomic.gff data/gff/Heinz1706.3_trimmed.gff
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

```bash
heinz_corrected_2=data/fasta/region/Heinz1706.2_SL2.50_corrected.fna 
heinz_corrected_3=data/fasta/region/Heinz1706.3_SL2.50_corrected.fna
m82_corrected=data/fasta/region/M82_corrected.fna 
fastq_1=data/fastq/ERR418079_1.fastq.gz
fastq_2=data/fastq/ERR418079_2.fastq.gz
```

The following commands will run the scripts as a slurm batch job:

```bash
for ref_genome in data/fasta/region/*.fna; do
    #echo "# Running analysis on: $ref_genome"
    sbatch scripts/align.sh "$ref_genome" "$fastq_1" "$fastq_2" "$outdir"
done
```

```bash
sbatch scripts/align.sh "$heinz_corrected_3" "$fastq_1" "$fastq_2" "$outdir"
```

## Call Variants and Filter for Deletions

This script takes a reference genome, a mapped and sorted BAM file, and an output directory as inputs and will output two vcf files. On file will be filtered to only contain deletions, the other file will contain both insertions and deletions.

```bash
heinz_ms_bam_2=results/aligned/Heinz1706.2_SL2.50_corrected.fna.mapped.sorted.bam
heinz_ms_bam_3=results/aligned/Heinz1706.3_SL2.50_corrected.fna.mapped.sorted.bam

bash scripts/call_and_filter.sh "$heinz_corrected_3" "$heinz_ms_bam_3" "$outdir"

```

