#!/bin/bash
set -euo pipefail

# Constants

start_pos=68765135
end_pos=68986544

# Input variables

input_gff="$1"
output_gff="$2"

# Inital Logging

echo "# Starting script gff_trim.sh"
date
echo "# Input Heinz 1706 GFF file:            $input_gff"
echo

#

awk -v chrom="NC_015440.2" -v start="$start_pos" -v end="$end_pos" '
BEGIN {FS="\t"; OFS="\t"}
$1 == chrom && $4 >= start && $5 <= end {print $0}
' "$input_gff" > "$output_gff"

# Final logging

echo
echo "# Successfully finished script gff_trim.sh"
date