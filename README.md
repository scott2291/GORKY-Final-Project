# GORKY Final Project Protocol

## Setting up

1. Download files and transfer via FileZilla

1. Unzip reference genome files

```bash
gunzip -v data/

```
1. Prepare VCF file for analysis

```bash
# Renaming my file so it does not confuse the script by stating it is double compressed
mv data/RF_043_SZAXPI009322-102.vcf.gz.snpeff.vcf.gz  data/RF_043_SZAXPI009322-102.snpeff.vcf.gz
#Load module htslib
module load htslib/1.20
# Unzip my VCF file
gunzip -d data/RF_043_SZAXPI009322-102.snpeff.vcf.gz 
# Block gunzip my file
bgzip data/RF_043_SZAXPI009322-102.snpeff.vcf 
# Create index file
tabix -p vcf data/RF_043_SZAXPI009322-102.snpeff.vcf.gz 

```

1. Set up files paths

```bash
#Inputs

inputvcf=data/RF_043_SZAXPI009322-102.snpeff.vcf.gz 
ref_heinz=data/fasta/Heinz1706_SL4.0_genomic.fna 
ref_m82=data/fasta/M82_genomic.fna 

# Output

outdir=results/

```

## File Preparation: Indel 3-5 Position Range

This will be completed via the `indel_position.sh` script which will take a VCF file for EA03058 and the results output directory as the two inputs. The script will produce two output variables that will contain the starting and ending positions of indel 5.

```bash
bash scripts/indel_position.sh "$inputvcf" "$outdir"

```
## File Preparation: Creating smaller fasta 

This script will accept both reference genome fasta files and an output directory as inputs and will output fasta files that only contain the regions I am interested in.

```bash
bash scripts/seqkit.sh "$ref_heinz_2" "$ref_m82" data/fasta/
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
heinz_corrected=data/fasta/region/Heinz1706.2_SL2.50_corrected.fna 
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

## Call Variants and Filter for Deletions

This script takes a reference genome, a mapped and sorted BAM file, and an output directory as inputs and will output two vcf files. On file will be filtered to only contain deletions, the other file will contain both insertions and deletions.

```bash
heinz_ms_bam=results/aligned/Heinz1706.2_SL2.50_corrected.fna.mapped.sorted.bam

bash scripts/call_and_filter.sh "$heinz_corrected" "$heinz_ms_bam" "$outdir"

```

