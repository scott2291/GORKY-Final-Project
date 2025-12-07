#!/bin/bash
set -euo pipefail

# Load Modules

module load htslib/1.20

# Constants

gffread=oras://community.wave.seqera.io/library/gffread:0.12.7--b08e770b84a4a126
#genometools=oras://community.wave.seqera.io/library/genometools:1.2.1--0747616f409ea579

# Input Variables

input_gff="$1"
filename=$(basename "$input_gff")

# Initial Logging

echo "# Starting script gff_to_gff3.sh"
date
echo "# Input file:                      $input_gff"
echo 
echo "# File basename:              $filename"

# Sort gff file

apptainer exec "$gffread" gffread "$input_gff" -E --sort-by -o data/gff/trimmed/"$filename".gff3


# Strict sort for tabix: keep headers first, then sort features


awk -F'\t' 'BEGIN{OFS="\t"} /^#/ {print; next} {print}' "data/gff/trimmed/${filename}.gff3" \
  | sort -k1,1 -k4,4n \
  > "data/gff/trimmed/${filename}.sorted.gff3"

# Compressing and index the file for JBrowse use

bgzip -@ 4 -c data/gff/trimmed/"$filename".sorted.gff3 > data/gff/trimmed/"$filename".sorted.gff3.bgz

tabix -p gff data/gff/trimmed/"$filename".sorted.gff3.bgz

# Final logging
echo
echo "# Used gffread version:"
apptainer exec "$gffread" gffread --version
echo "# Successfully finished script indel_position.sh"
date