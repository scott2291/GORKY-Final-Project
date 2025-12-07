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
 
apptainer exec "$gffread" gffread "$input_gff" -E \
-o - | awk 'BEGIN{fasta=0} /^##FASTA/{fasta=1} fasta==0{print $0}' > data/gff/trimmed/"$filename".gff3

# Strict sort for tabix: keep headers first, then sort features

{
  grep '^#' "data/gff/trimmed/${filename}.gff3"
  grep -v '^#' "data/gff/trimmed/${filename}.gff3" \
    | LC_ALL=C sort -t $'\t' -k1,1 -k4,4n -k5,5n
} > "data/gff/trimmed/${filename}.sorted.gff3"


# Compressing and index the file for JBrowse use

bgzip -@ 4 -c data/gff/trimmed/"$filename".sorted.gff3 > data/gff/trimmed/"$filename".sorted.gff3.bgz

tabix -f -p gff "data/gff/trimmed/${filename}.sorted.gff3.bgz"
# Final logging
echo
echo "# Used gffread version:"
apptainer exec "$gffread" gffread --version
echo "# Successfully finished script gff_to_gff3.sh"
date