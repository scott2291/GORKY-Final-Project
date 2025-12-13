#!/bin/bash
set -euo pipefail

# Constants
sratools=oras://community.wave.seqera.io/library/sra-tools:3.2.1--846898724ee33c64

# Initial Logging

echo "# Starting script sra-download.sh"
date
echo

# Download the SRA file

apptainer exec "$sratools" prefetch ERR11752506

# Convert SRA to FASTQ

apptainer exec "$sratools" fasterq-dump ERR11752506/ERR11752506.sra --split-files --threads 8 --progress \
--outdir data/fastq/

# Gzip fastq files

gzip data/fastq/ERR11752506_1.fastq
gzip data/fastq/ERR11752506_2.fastq

# Delete uneeded sra file 

rm -r ERR11752506

# Final Logging

echo
echo "# Used sra-tools version:"
apptainer exec "$sratools"  prefetch --version
echo "# Successfully finished script sra-download.sh"
date