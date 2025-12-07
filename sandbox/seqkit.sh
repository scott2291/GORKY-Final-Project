#!/bin/bash
set -euo pipefail

# Constants

seqkit=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3
start_pos=68765135
end_pos=68986544

# Input variables

ref_heinz_2="$1"
ref_m82="$3"
ref_heinz_3="$2"
outdir="$4"

# Inital Logging

echo "# Starting script seqkit.sh"
date
echo "# Input Heinz 1706.2 Ref Genome:            $ref_heinz_2"
echo
echo "#Input Heinz 1707.3 Ref Genome:              $ref_heinz_3"
echo
echo "# Input M82 ref genome:               $ref_m82"
echo
#echo "# Name of Chromosome 3 Heinz1706:       $heinz_chr3_name"
#echo
#echo "# Name of Chromosome 3 M82:              $m82_chr3_name"
#echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store new files

mkdir -p "$outdir"region


# Use seqkit to create a new file that only contains the specified region for our Heinz 1706.2 reference genome

apptainer exec "$seqkit" seqkit subseq --chr CM001066.2 --region "$start_pos":"$end_pos" "$ref_heinz_2" > "$outdir"region/Heinz1706.2_SL2.50_corrected.fna 

# Use seqkit to create a new file that only contains the specified region for our Heinz 1706.3 reference genome

apptainer exec "$seqkit" seqkit subseq --chr NC_015440.2 --region "$start_pos":"$end_pos" "$ref_heinz_3" > "$outdir"region/Heinz1706.3_SL2.50_corrected.fna 

# Use seqkit to create a new file that only contains the specified region for our M82 reference genome

apptainer exec "$seqkit" seqkit subseq --chr CM079133.1 --region "$start_pos":"$end_pos" "$ref_m82" > "$outdir"region/M82_corrected.fna 

# Final logging

echo
echo "# Used seqkit version:"
apptainer exec "$seqkit" seq --version
echo "# Successfully finished script seqkit.sh"
date