#!/usr/bin/env bash

# This file was suggested by Michael Steinbaugh for the RNAEditingIndex.

set -Eeu -o pipefail

# Configure conda.
conda install --yes \
    bamutil=1.0.14 \
    bedtools=2.29.2 \
    python=2.7.16 \
    samtools=1.9
conda install --yes --channel=cyclus java-jdk=8.0.92
conda install --yes --channel=anaconda git

# Clone the git repo.

### git  clone --recursive
git clone \
    https://github.com/shalomhillelroth/BEIndexer \
    /bin/BEIndexer/BEIndexer

# Build the program.
(
    cd /bin/BEIndexer/BEIndexer || exit 1

    ./configure \
    BEDTOOLS_PATH=bedtools \
    SAMTOOLS_PATH=samtools \
    RESOURCES_DIR=/bin/BEIndexer/BEIndexer/Resources \
    JAVA_HOME=/opt/conda \
    BAM_UTILS_PATH=bam \
    PYTHON27_PATH=python \
    DONT_DOWNLOAD=false \
    DONT_WRITE=false

    make
)

# Index genome FASTA files using samtools.
find /bin/BEIndexer/BEIndexer/Resources/Genomes \
    -type f -name "*.fa" \
    -print0 | xargs -0 -I {} \
        samtools faidx {}
        

chmod -fR 777 /bin/BEIndexer