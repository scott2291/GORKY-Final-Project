# GORKY Final Project Protocol

## Setting up

1. Download files and transfer via FileZilla

2. Unzip reference genome files

```bash
gunzip -v data/

```

3. Set up files paths

```bash
#Inputs
inputvcf=data/RF_043_SZAXPI009322-102.vcf.gz.snpeff.vcf.gz 
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

