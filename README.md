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
## File Preparation: Creating smaller fasta and fastq files

```bash
bash scripts/seqkit.sh "$ref_heinz" "$ref_m82" data/fasta/
```

