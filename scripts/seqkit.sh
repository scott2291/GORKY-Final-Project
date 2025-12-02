#!/bin/bash
set -euo pipefail

# Constants

seqkit=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3
start_pos=68765135
end_pos=68986544
# Input variables

ref_heinz="$1"
ref_m82="$2"
outdir="$3"

# Inital Logging

echo "# Starting script seqkit.sh"
date
echo "# Input Heinz 1706 Ref Genome:            $ref_heinz"
echo
echo "# Input M82 ref genome:               $ref_m82"
echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store

mkdir -p "$outdir"region


# Use seqkit to create a new file that only contains the specified region for our Heinz 1706 reference genome

apptainer exec "$seqkit" seqkit subseq --chr SL2.50ch03 --region "$start_pos":"$end_pos" "$ref_heinz" > "$outdir"region/Heinz1706_SL4.0_corrected.fna 

# Use seqkit to create a new file that only contains the specified region for our M82 reference genome

apptainer exec "$seqkit" seqkit subseq --chr CM079133.1 Solanum lycopersicum cultivar M82 isolate SW-2024b chromosome 3, whole genome shotgun sequence --region "$start_pos":"$end_pos" "$ref_m82" > "$outdir"region/M82_corrected.fna 

# Final logging

echo
echo "# Used bcftools version:"
apptainer exec "$seqkit" bcftools --version
echo "# Successfully finished script indel_position.sh"
date