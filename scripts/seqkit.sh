#!/bin/bash
set -euo pipefail

# Constants

seqkit=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3
start_pos=68765135
end_pos=68986544

# Input variables

ref_heinz_2="$1"
ref_m82="$2"
outdir="$3"

# Create variable that contains the name of chromosome 3

#heinz_chr3_name="CM001066.4 Solanum lycopersicum cultivar Heinz 1706 chromosome 3, whole genome shotgun sequence"

#m82_chr3_name="CM079133.1 Solanum lycopersicum cultivar M82 isolate SW-2024b chromosome 3, whole genome shotgun sequence"

# Inital Logging

echo "# Starting script seqkit.sh"
date
echo "# Input Heinz 1706 Ref Genome:            $ref_heinz_2"
echo
echo "# Input M82 ref genome:               $ref_m82"
echo
#echo "# Name of Chromosome 3 Heinz1706:       $heinz_chr3_name"
#echo
#echo "# Name of Chromosome 3 M82:              $m82_chr3_name"
#echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store

mkdir -p "$outdir"region


# Use seqkit to create a new file that only contains the specified region for our Heinz 1706 reference genome

apptainer exec "$seqkit" seqkit subseq --chr CM001066.2 --region "$start_pos":"$end_pos" "$ref_heinz_2" > "$outdir"region/Heinz1706.2_SL2.50_corrected.fna 

# Use seqkit to create a new file that only contains the specified region for our M82 reference genome

apptainer exec "$seqkit" seqkit subseq --chr CM079133.1 --region "$start_pos":"$end_pos" "$ref_m82" > "$outdir"region/M82_corrected.fna 

# Final logging

echo
echo "# Used seqkit version:"
apptainer exec "$seqkit" seq --version
echo "# Successfully finished script indel_position.sh"
date