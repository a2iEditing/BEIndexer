#!/usr/bin/env bash

# This work is licensed under the Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International License.
# To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
# For use of the software by commercial entities, please inquire with Tel Aviv University at ramot@ramot.org.
# (c) 2019 Tel Aviv University (Erez Y. Levanon, Erez.Levanon@biu.ac.il;
# Eli Eisenberg, elieis@post.tau.ac.il;
# Shalom Hillel Roth, shalomhillel.roth@live.biu.ac.il).

RESOURCES_DIR=${1:-"../Resources"};
LIB_DIR=${2:-"../lib"};
DBS_PATHS_INI=${3:-"${RESOURCES_DIR}/ResourcesPaths.ini"};
DONT_DOWNLOAD=${4:-false}
DONT_WRITE=${5:-false}
BEDTOOLS_PATH=${6:-"bedtools"}
SAMTOOLS_PATH=${7:-"samtools"}
JAVA_HOME=${8:-"/usr"}
BAM_UTILS_PATH=${9:-"bam"}
DONT_GENERATE_GENOME_INDEXES=${10:-false}
DEV_ROOT=${11:-"."}

#---------------------------------------------------------------------------
# Constants
#---------------------------------------------------------------------------
HUMAN="HomoSapiens"
MURINE="MusMusculus"

HG38_FTP_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/"
HG38_FTP_GENOME_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/"

HG19_FTP_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/"
HG19_FTP_GENOME_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/"

MURINE_GENE_EXPRESSION_FTP="http://chromosome.sdsc.edu/mouse/download/"
MURINE_GENE_EXPRESSION_FILE="19-tissues-expr.zip"
MURINE_GENE_EXPRESSION_FOLDER="19-tissues-expr"

MM10_FTP_URL="http://hgdownload.soe.ucsc.edu/goldenPath/mm10/database/"
MM10_FTP_GENOME_URL="http://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/"

MM9_FTP_URL="http://hgdownload.soe.ucsc.edu/goldenPath/mm9/database/"
MM9_FTP_GENOME_URL="http://hgdownload.soe.ucsc.edu/goldenPath/mm9/bigZips/"

GENOME_DIR="Genomes"
HUMAN_GENOME_DIR="${RESOURCES_DIR}/${GENOME_DIR}/${HUMAN}"
HG38_GENOME_FASTA_FILE="hg38.fa.gz"
HG38_GENOME_FASTA="ucscHg38Genome.fa"
HG19_GENOME_FASTA_FILE="chromFa.tar.gz"
HG19_GENOME_FASTA="ucscHg19Genome.fa"

MURINE_GENOME_DIR="${RESOURCES_DIR}/${GENOME_DIR}/${MURINE}"
MM10_GENOME_FASTA_FILE="chromFa.tar.gz"
MM10_GENOME_FASTA="ucscMm10Genome.fa"
MM9_GENOME_FASTA_FILE="chromFa.tar.gz"
MM9_GENOME_FASTA="ucscMM9Genome.fa"


REGIONS_DIR="Regions"
HUMAN_REGIONS_DIR="${RESOURCES_DIR}/${REGIONS_DIR}/${HUMAN}"
HG38_REGIONS_FILE="ucscHg38Alu.bed.gz"
HG38_CDS_REGIONS_FILE="ucscHg38CDS.bed.gz"
HG38_CDS_REFSEQ_ALL_REGIONS_FILE="ucscHg38CDSRefSeqAll.bed.gz"
HG38_REGIONS_TABLE_FILE="rmsk.txt.gz"
HG19_REGIONS_FILE="ucscHg19Alu.bed.gz"
HG19_CDS_REGIONS_FILE="ucscHg19CDS.bed.gz"
HG19_CDS_REFSEQ_ALL_REGIONS_FILE="ucscHg19CDSRefSeqAll.bed.gz"
HG19_REGIONS_TABLE_FILE="rmsk.txt.gz"

MURINE_REGIONS_DIR="${RESOURCES_DIR}/${REGIONS_DIR}/${MURINE}"
MM10_REGIONS_FILE="ucscMM10SINE_B1_B2.bed.gz"
MM10_CDS_REGIONS_FILE="ucscMM10CDS.bed.gz"
MM10_CDS_REFSEQ_ALL_REGIONS_FILE="ucscMM10CDSRefSeqAll.bed.gz"
MM10_REGIONS_TABLE_FILE="rmsk.txt.gz"
MM9_REGIONS_FILE="ucscMM9SINE_B1_B2.bed.gz"
MM9_CDS_REGIONS_FILE="ucscMM9CDS.bed.gz"
MM9_REGIONS_TABLES=("chr1_rmsk.txt.gz  chr2_rmsk.txt.gz  chr3_rmsk.txt.gz chr4_rmsk.txt.gz chr5_rmsk.txt.gz chr6_rmsk.txt.gz chr7_rmsk.txt.gz chr8_rmsk.txt.gz chr9_rmsk.txt.gz chr10_rmsk.txt.gz chr11_rmsk.txt.gz chr12_rmsk.txt.gz chr13_rmsk.txt.gz chr14_rmsk.txt.gz chr15_rmsk.txt.gz chr16_rmsk.txt.gz chr17_rmsk.txt.gz chr18_rmsk.txt.gz chr19_rmsk.txt.gz chrM_rmsk.txt.gz chrX_rmsk.txt.gz chrY_rmsk.txt.gz")
MM9_REGIONS_TABLE_FILES="chr1_rmsk.txt.gz  chr2_rmsk.txt.gz  chr3_rmsk.txt.gz chr4_rmsk.txt.gz chr5_rmsk.txt.gz chr6_rmsk.txt.gz chr7_rmsk.txt.gz chr8_rmsk.txt.gz chr9_rmsk.txt.gz chr10_rmsk.txt.gz chr11_rmsk.txt.gz chr12_rmsk.txt.gz chr13_rmsk.txt.gz chr14_rmsk.txt.gz chr15_rmsk.txt.gz chr16_rmsk.txt.gz chr17_rmsk.txt.gz chr18_rmsk.txt.gz chr19_rmsk.txt.gz chrM_rmsk.txt.gz chrX_rmsk.txt.gz chrY_rmsk.txt.gz"
MM9_REGIONS_TABLE_COMBINED="mm9_rmsk_combined.gz"


SNPS_DIR="SNPs"
HUMAN_SNPS_DIR="${RESOURCES_DIR}/${SNPS_DIR}/${HUMAN}"
HG38_SNPS_FILE="ucscHg38CommonGenomicSNPs150.bed.gz"
HG38_SNPS_TABLE_FILE="snp150Common.txt.gz"
HG19_SNPS_FILE="ucscHg19CommonGenomicSNPs150.bed.gz"
HG19_SNPS_TABLE_FILE="snp150Common.txt.gz"

MURINE_SNPS_DIR="${RESOURCES_DIR}/${SNPS_DIR}/${MURINE}"
MM10_SNPS_FILE="ucscMM10CommonGenomicSNPs142.bed.gz"
MM10_SNPS_TABLE_FILE="snp142Common.txt.gz"
MM9_SNPS_FILE="ucscMM9CommonGenomicSNPs128.bed.gz"
MM9_SNPS_TABLE_FILE="snp128.txt.gz"


REFSEQ_DIR="RefSeqAnnotations"
HUMAN_REFSEQ_DIR="${RESOURCES_DIR}/${REFSEQ_DIR}/${HUMAN}"
HG38_REFSEQ_TABLE_FILE="ncbiRefSeqCurated.txt.gz"
HG38_ALL_REFSEQ_TABLE_FILE="ncbiRefSeq.txt.gz"
HG38_REFSEQ_FILE="ucscHg38RefSeqCurated.bed.gz"
HG38_ALL_REFSEQ_FILE="ucscHg38RefSeqAll.bed.gz"
HG19_REFSEQ_TABLE_FILE="ncbiRefSeqCurated.txt.gz"
HG19_ALL_REFSEQ_TABLE_FILE="ncbiRefSeq.txt.gz"
HG19_REFSEQ_FILE="ucscHg19RefSeqCurated.bed.gz"
HG19_ALL_REFSEQ_FILE="ucscHg19RefSeqAll.bed.gz"

MURINE_REFSEQ_DIR="${RESOURCES_DIR}/${REFSEQ_DIR}/${MURINE}"
MM10_REFSEQ_TABLE_FILE="ncbiRefSeqCurated.txt.gz"
MM10_REFSEQ_FILE="ucscMM10RefSeqCurated.bed.gz"
MM10_ALL_REFSEQ_TABLE_FILE="ncbiRefSeq.txt.gz"
MM10_ALL_REFSEQ_FILE="ucscMM10RefSeqAll.bed.gz"
MM9_REFSEQ_TABLE_FILE="refGene.txt.gz"
MM9_REFSEQ_FILE="ucscMM9RefSeqCurated.bed.gz"
## MM9 has only a general RefSeq table...

GENES_EXPRESSION_DIR="GenesExpression"
HUMAN_GENES_EXPRESSION_DIR="${RESOURCES_DIR}/${GENES_EXPRESSION_DIR}/${HUMAN}"
HG38_GENES_EXPRESSION_FILE="ucscHg38GTExGeneExpression.bed.gz"
HG38_GENES_EXPRESSION_TABLE_FILE="gtexGene.txt.gz"
HG19_GENES_EXPRESSION_FILE="ucscHg19GTExGeneExpression.bed.gz"
HG19_GENES_EXPRESSION_TABLE_FILE="gtexGene.txt.gz"

MURINE_GENES_EXPRESSION_DIR="${RESOURCES_DIR}/${GENES_EXPRESSION_DIR}/${MURINE}"
MM10_GENES_EXPRESSION_FILE="ucscMM10GTExGeneExpression.bed.gz"
MM9_GENES_EXPRESSION_FILE="ucscMM9GTExGeneExpression.bed.gz"

#---------------------------------------------------------------------------
# Downloading
#---------------------------------------------------------------------------

if [ "${DONT_DOWNLOAD}" = false ]
then

  # clean folders from previous runs
  echo "Info: Trying to delete old resource files"
  find "${RESOURCES_DIR}" -type f -delete

  mkdir -p "${HUMAN_GENOME_DIR}"
  mkdir -p "${MURINE_GENOME_DIR}"

  mkdir -p "${HUMAN_REGIONS_DIR}"
  mkdir -p "${MURINE_REGIONS_DIR}"

  mkdir -p "${HUMAN_SNPS_DIR}"
  mkdir -p "${MURINE_SNPS_DIR}"

  mkdir -p "${HUMAN_REFSEQ_DIR}"
  mkdir -p "${MURINE_REFSEQ_DIR}"

  mkdir -p "${HUMAN_GENES_EXPRESSION_DIR}"
  mkdir -p "${MURINE_GENES_EXPRESSION_DIR}"


  echo "Info: Started Downloading UCSC Resources.
  "
  #---------------------------------------------------------------------------
  # HG38
  #---------------------------------------------------------------------------
  echo "Info: Started Downloading Hg38 Files:"

  # Genome
  echo "Downloading Hg38 Genome: ${HG38_FTP_GENOME_URL}${HG38_GENOME_FASTA_FILE}"
  wget "${HG38_FTP_GENOME_URL}${HG38_GENOME_FASTA_FILE}"  --directory-prefix="${HUMAN_GENOME_DIR}"
  echo "Saving Hg38 Genome Under: ${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}"
  gunzip -c "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA_FILE}" > "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}"
  rm "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA_FILE}"
  echo "Done Processing Hg38 Genome"

  # Repeats Regions
  echo "Downloading Hg38 Alu Repeats Table ${HG38_FTP_URL}${HG38_REGIONS_TABLE_FILE}"
  wget "${HG38_FTP_URL}${HG38_REGIONS_TABLE_FILE}"  --directory-prefix="${HUMAN_REGIONS_DIR}"
  echo "Processing Hg38  Alu Repeats Table ${HG38_REGIONS_TABLE_FILE}"
  zcat "${HUMAN_REGIONS_DIR}/${HG38_REGIONS_TABLE_FILE}"| awk '{OFS ="\t"}($13 ~/Alu/ && $6 !~/_/) {print $6,$7,$8}' | ${BEDTOOLS_PATH} sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > "${HUMAN_REGIONS_DIR}/${HG38_REGIONS_FILE}"
  rm "${HUMAN_REGIONS_DIR}/${HG38_REGIONS_TABLE_FILE}"
  echo "Done Processing Hg38 Alu Repeats Table ${HG38_REGIONS_TABLE_FILE}"
  # Generate Indexes
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of Hg38 Alu Repeats ${HG38_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG38_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG38_GENOME_FASTA}.${HG38_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # SNPs
  echo "Downloading Hg38 Common Genomic SNPs Table ${HG38_FTP_URL}${HG38_SNPS_TABLE_FILE}"
  wget "${HG38_FTP_URL}${HG38_SNPS_TABLE_FILE}"  --directory-prefix="${HUMAN_SNPS_DIR}"
  echo "Processing Hg38Common Genomic SNPs Table ${HG38_SNPS_TABLE_FILE}"
  zcat "${HUMAN_SNPS_DIR}/${HG38_SNPS_TABLE_FILE}" | awk '{OFS ="\t"}($11=="genomic") {print $2,$3,$4,$7,$9,$10,$16,$25}'| gzip > "${HUMAN_SNPS_DIR}/${HG38_SNPS_FILE}"
  rm "${HUMAN_SNPS_DIR}/${HG38_SNPS_TABLE_FILE}"
  echo "Done Processing Hg38 Common Genomic SNPs Table ${HG38_SNPS_TABLE_FILE}"

  # RefSeq
  echo "Downloading Hg38 RefSeq Curated Table ${HG38_FTP_URL}${HG38_REFSEQ_TABLE_FILE}"
  wget "${HG38_FTP_URL}${HG38_REFSEQ_TABLE_FILE}"  --directory-prefix="${HUMAN_REFSEQ_DIR}"
  echo "Processing Hg38 RefSeq Curated Table ${HG38_REFSEQ_TABLE_FILE}"
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' |gzip > "${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}.Exons.bed"
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > \
  "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}"

  rm "${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_TABLE_FILE}" "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}.Exons.bed"
  echo "Done Processing Hg38 RefSeq Curated Table ${HG38_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDSs
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of Hg38 CDS Regions ${HG38_CDS_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG38_GENOME_FASTA}.${HG38_CDS_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi


  # RefSeq All
  echo "Downloading Hg38 RefSeq All Table ${HG38_FTP_URL}${HG38_ALL_REFSEQ_TABLE_FILE}"
  wget "${HG38_FTP_URL}${HG38_ALL_REFSEQ_TABLE_FILE}"  --directory-prefix="${HUMAN_REFSEQ_DIR}"
  echo "Processing Hg38 RefSeq Curated Table ${HG38_ALL_REFSEQ_TABLE_FILE}"
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' | \
    gzip > "${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  zcat "${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > \
  "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}"

  rm "${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_TABLE_FILE}" "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  echo "Done Processing Hg38 RefSeq Curated Table ${HG38_ALL_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDSs
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of Hg38 CDS Regions (RefSeq All) ${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG38_GENOME_FASTA}.${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # Genes Expression
  echo "Downloading Hg38 Genes Expression Table ${HG38_FTP_URL}${HG38_GENES_EXPRESSION_TABLE_FILE}"
  wget "${HG38_FTP_URL}${HG38_GENES_EXPRESSION_TABLE_FILE}"  --directory-prefix="${HUMAN_GENES_EXPRESSION_DIR}"
  echo "Processing Hg38 Genes Expression Table ${HG38_GENES_EXPRESSION_TABLE_FILE}"
  zcat "${HUMAN_GENES_EXPRESSION_DIR}/${HG38_GENES_EXPRESSION_TABLE_FILE}" | awk '{OFS ="\t"} {print $1,$2,$3,$4,$10,$6}'| gzip > "${HUMAN_GENES_EXPRESSION_DIR}/${HG38_GENES_EXPRESSION_FILE}"
  rm "${HUMAN_GENES_EXPRESSION_DIR}/${HG38_GENES_EXPRESSION_TABLE_FILE}"
  echo "Done Processing Hg38 Genes Expression Table ${HG38_GENES_EXPRESSION_TABLE_FILE}"


  #---------------------------------------------------------------------------
  # HG19
  #---------------------------------------------------------------------------

  echo "Info: Started Downloading Hg19 Files:"

  # Genome
  echo "Downloading Hg19 Genome: ${HG19_FTP_GENOME_URL}${HG19_GENOME_FASTA_FILE}"
  wget "${HG19_FTP_GENOME_URL}${HG19_GENOME_FASTA_FILE}"  --directory-prefix="${HUMAN_GENOME_DIR}"
  echo "Saving Hg19 Genome Under: ${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}"
  tar -xOzf "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA_FILE}" | cat > "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}"
  rm "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA_FILE}"
  echo "Done Processing Hg19 Genome"

  # Repeats Regions
  echo "Downloading HG19 Alu Repeats Table ${HG19_FTP_URL}${HG19_REGIONS_TABLE_FILE}"
  wget "${HG19_FTP_URL}${HG19_REGIONS_TABLE_FILE}"  --directory-prefix="${HUMAN_REGIONS_DIR}"
  echo "Processing HG19 Alu Repeats Table ${HG19_REGIONS_TABLE_FILE}"
  zcat "${HUMAN_REGIONS_DIR}/${HG19_REGIONS_TABLE_FILE}"| awk '{OFS ="\t"}($13 ~/Alu/ && $6 !~/_/) {print $6,$7,$8}' | ${BEDTOOLS_PATH} sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin|  gzip > "${HUMAN_REGIONS_DIR}/${HG19_REGIONS_FILE}"
  rm "${HUMAN_REGIONS_DIR}/${HG19_REGIONS_TABLE_FILE}"
  echo "Done Processing HG19 Alu Repeats Table ${HG19_REGIONS_TABLE_FILE}"

  # Generate Indexes
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of Hg19 Alu Repeats ${HG19_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG19_REGIONS_FILE}"  -g "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG19_GENOME_FASTA}.${HG19_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # SNPs
  echo "Downloading HG19 Common Genomic SNPs Table ${HG19_FTP_URL}${HG19_SNPS_TABLE_FILE}"
  wget "${HG19_FTP_URL}${HG19_SNPS_TABLE_FILE}"  --directory-prefix="${HUMAN_SNPS_DIR}"
  echo "Processing HG19 Common Genomic SNPs Table ${HG19_SNPS_TABLE_FILE}"
  zcat "${HUMAN_SNPS_DIR}/${HG19_SNPS_TABLE_FILE}" | awk '{OFS ="\t"}($11=="genomic") {print $2,$3,$4,$7,$9,$10,$16,$25}'| gzip > "${HUMAN_SNPS_DIR}/${HG19_SNPS_FILE}"
  rm "${HUMAN_SNPS_DIR}/${HG19_SNPS_TABLE_FILE}"
  echo "Done Processing HG19 Common Genomic SNPs Table ${HG19_SNPS_TABLE_FILE}"

  # RefSeq
  echo "Downloading HG19 RefSeq Curated Table ${HG19_FTP_URL}${HG19_REFSEQ_TABLE_FILE}"
  wget "${HG19_FTP_URL}${HG19_REFSEQ_TABLE_FILE}"  --directory-prefix="${HUMAN_REFSEQ_DIR}"
  echo "Processing HG19 RefSeq Curated Table ${HG19_REFSEQ_TABLE_FILE}"
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' |gzip > "${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}.Exons.bed"
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin | ${BEDTOOLS_PATH} merge -i stdin| gzip > \
  "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}"

  rm "${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_TABLE_FILE}" "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}.Exons.bed"
  echo "Done Processing HG19 RefSeq Curated Table ${HG19_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDSs
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of HG19 CDS Regions ${HG19_CDS_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG19_GENOME_FASTA}.${HG19_CDS_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # RefSeq All
  echo "Downloading Hg19 RefSeq All Table ${HG19_FTP_URL}${HG19_ALL_REFSEQ_TABLE_FILE}"
  wget "${HG19_FTP_URL}${HG19_ALL_REFSEQ_TABLE_FILE}"  --directory-prefix="${HUMAN_REFSEQ_DIR}"
  echo "Processing HG19 RefSeq Curated Table ${HG19_ALL_REFSEQ_TABLE_FILE}"
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' | \
    gzip > "${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  zcat "${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > \
  "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}"

  rm "${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_TABLE_FILE}" "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  echo "Done Processing Hg19 RefSeq Curated Table ${HG19_ALL_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDSs
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of HG19 CDS Regions (RefSeq All) ${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${HG19_GENOME_FASTA}.${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # Genes Expression
  echo "Downloading Hg19 Genes Expression Table ${HG19_FTP_URL}${HG19_GENES_EXPRESSION_TABLE_FILE}"
  wget "${HG19_FTP_URL}${HG19_GENES_EXPRESSION_TABLE_FILE}"  --directory-prefix="${HUMAN_GENES_EXPRESSION_DIR}"
  echo "Processing Hg19 Genes Expression Table ${HG19_GENES_EXPRESSION_TABLE_FILE}"
  zcat "${HUMAN_GENES_EXPRESSION_DIR}/${HG19_GENES_EXPRESSION_TABLE_FILE}" | awk '{OFS ="\t"} {print $1,$2,$3,$4,$10,$6}'| gzip > "${HUMAN_GENES_EXPRESSION_DIR}/${HG19_GENES_EXPRESSION_FILE}"
  rm "${HUMAN_GENES_EXPRESSION_DIR}/${HG19_GENES_EXPRESSION_TABLE_FILE}"
  echo "Done Processing Hg19 Genes Expression Table ${HG19_GENES_EXPRESSION_TABLE_FILE}"

  #---------------------------------------------------------------------------
  # MM10
  #---------------------------------------------------------------------------
  echo "Info: Started Downloading MM10 Files:"

  # Genome
  echo "Downloading MM10 Genome: ${MM10_FTP_GENOME_URL}${MM10_GENOME_FASTA_FILE}"
  wget "${MM10_FTP_GENOME_URL}${MM10_GENOME_FASTA_FILE}"  --directory-prefix="${MURINE_GENOME_DIR}"
  echo "Saving MM10 Genome Under: ${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA}"
  tar -xOzf "${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA_FILE}" | cat > "${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA}"
  rm "${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA_FILE}"
  echo "Done Processing MM10 Genome"

  # Repeats Regions
  echo "Downloading MM10 B1 and B2 Repeats Table ${MM10_FTP_URL}${MM10_REGIONS_TABLE_FILE}"
  wget "${MM10_FTP_URL}${MM10_REGIONS_TABLE_FILE}"  --directory-prefix="${MURINE_REGIONS_DIR}"
  echo "Processing MM10  B1 and B2 Repeats Table ${MM10_REGIONS_TABLE_FILE}"
  zcat "${MURINE_REGIONS_DIR}/${MM10_REGIONS_TABLE_FILE}"| awk '{OFS ="\t"} (($13 ~/Alu/||$13 ~/^B2/) && $12 == "SINE"){print $6,$7,$8}' | ${BEDTOOLS_PATH} sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin|  gzip > "${MURINE_REGIONS_DIR}/${MM10_REGIONS_FILE}"
  rm "${MURINE_REGIONS_DIR}/${MM10_REGIONS_TABLE_FILE}"
  echo "Done Processing MM10 B1 and B2 Repeats Table ${MM10_REGIONS_TABLE_FILE}"

  # Generate Indexes
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of MM10 B1 and B2 Repeats ${MM10_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${MURINE_REGIONS_DIR}/${MM10_REGIONS_FILE}" -g "${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA}" \
      -o "${MURINE_REGIONS_DIR}/${MM10_GENOME_FASTA}.${MM10_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # SNPs
  echo "Downloading MM10 Common Genomic SNPs Table ${MM10_FTP_URL}${MM10_SNPS_TABLE_FILE}"
  wget "${MM10_FTP_URL}${MM10_SNPS_TABLE_FILE}"  --directory-prefix="${MURINE_SNPS_DIR}"
  echo "Processing MM10 Genomic SNPs Table ${MM10_SNPS_TABLE_FILE}"
  zcat "${MURINE_SNPS_DIR}/${MM10_SNPS_TABLE_FILE}" | awk '{OFS ="\t"}($11=="genomic") {print $2,$3,$4,$7,$9,$10,$16,$25}'| gzip > "${MURINE_SNPS_DIR}/${MM10_SNPS_FILE}"
  rm "${MURINE_SNPS_DIR}/${MM10_SNPS_TABLE_FILE}"
  echo "Done Processing MM10 Common Genomic SNPs Table ${MM10_SNPS_TABLE_FILE}"

  # RefSeq
  echo "Downloading MM10 RefSeq Curated Table ${MM10_FTP_URL}${MM10_REFSEQ_TABLE_FILE}"
  wget "${MM10_FTP_URL}${MM10_REFSEQ_TABLE_FILE}"  --directory-prefix="${MURINE_REFSEQ_DIR}"
  echo "Processing MM10 RefSeq Curated Table ${MM10_REFSEQ_TABLE_FILE}"
  zcat "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' |gzip > "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}.Exons.bed"
  zcat "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin | gzip > \
  "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}"

  rm "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_TABLE_FILE}" "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}.Exons.bed"
  echo "Done Processing MM10 RefSeq Curated Table ${MM10_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDS
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of MM10 CDS ${MM10_CDS_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}" -g "${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA}" \
      -o "${MURINE_REGIONS_DIR}/${MM10_GENOME_FASTA}.${MM10_CDS_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # RefSeq All
  echo "Downloading MM10 RefSeq All Table ${MM10_FTP_URL}${MM10_ALL_REFSEQ_TABLE_FILE}"
  wget "${MM10_FTP_URL}${MM10_ALL_REFSEQ_TABLE_FILE}"  --directory-prefix="${MURINE_REFSEQ_DIR}"
  echo "Processing MM10 RefSeq Curated Table ${MM10_ALL_REFSEQ_TABLE_FILE}"
  zcat "${HUMAN_REFSEQ_DIR}/${MM10_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' | \
    gzip > "${HUMAN_REFSEQ_DIR}/${MM10_ALL_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${HUMAN_REFSEQ_DIR}/${MM10_ALL_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  zcat "${HUMAN_REFSEQ_DIR}/${MM10_ALL_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > \
  "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}"

  rm "${HUMAN_REFSEQ_DIR}/${MM10_ALL_REFSEQ_TABLE_FILE}" "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}.Exons.bed"
  echo "Done Processing MM10 RefSeq Curated Table ${MM10_ALL_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDSs
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of MM10 CDS Regions (RefSeq All) ${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${HUMAN_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}" -g "${HUMAN_GENOME_DIR}/${MM10_GENOME_FASTA}" \
      -o "${HUMAN_REGIONS_DIR}/${MM10_GENOME_FASTA}.${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # Genes Expression
  echo "Warning: Murine Gene Expression was derived from ENCODE table from 2013 for MM9! (Newer Data was not available)"
  echo "Downloading Murine Genes Expression Table ${MURINE_GENE_EXPRESSION_FTP}/${MURINE_GENE_EXPRESSION_FILE}"
  wget "${MURINE_GENE_EXPRESSION_FTP}/${MURINE_GENE_EXPRESSION_FILE}"  --directory-prefix="${MURINE_GENES_EXPRESSION_DIR}"
  echo "Processing MM10Genes Expression File ${MURINE_GENE_EXPRESSION_FILE}"
  if cd "${MURINE_GENES_EXPRESSION_DIR}"
  then
    unzip "${MURINE_GENES_EXPRESSION_DIR}/${MURINE_GENE_EXPRESSION_FILE}"
    rm "${MURINE_GENES_EXPRESSION_DIR}/${MURINE_GENE_EXPRESSION_FILE}"
    ${PYTHON27_PATH} "${DEV_ROOT:?}/make/compileMouseEncodeGeneExpression.py" "${MURINE_GENES_EXPRESSION_DIR}/${MURINE_GENE_EXPRESSION_FOLDER}"  "${MURINE_GENES_EXPRESSION_DIR}/${MM10_GENES_EXPRESSION_FILE}" "${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_FILE}"
    echo "Done Processing MM10 Genes Expression From Tables ${MURINE_GENE_EXPRESSION_FILE}"
  else
     echo "Failed to Process MM10 Files (cd command fails)"
  fi

  #---------------------------------------------------------------------------
  # MM9
  #---------------------------------------------------------------------------
  echo "Info: Started Downloading MM9 Files:"

  # Genome
  echo "Downloading MM9 Genome: ${MM9_FTP_GENOME_URL}${MM9_GENOME_FASTA_FILE}"
  wget "${MM9_FTP_GENOME_URL}${MM9_GENOME_FASTA_FILE}"  --directory-prefix="${MURINE_GENOME_DIR}"
  echo "Saving MM9 Genome Under: ${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA}"
  tar -xOzf "${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA_FILE}" | cat > "${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA}"
  rm "${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA_FILE}"
  echo "Done Processing MM9 Genome"

  # Repeats Regions
  for table in ${MM9_REGIONS_TABLES[*]}
  do
  echo "Downloading MM9 B1 and B2 Repeats Table ${MM9_FTP_URL}${table}"
  wget "${MM9_FTP_URL}${table}"  --directory-prefix="${MURINE_REGIONS_DIR}"
  done

  echo "Processing MM9  B1 and B2 Repeats Table ${MM9_REGIONS_TABLE_FILES}"
  if cd "${MURINE_REGIONS_DIR}"
  then
    cat "${MM9_REGIONS_TABLE_FILES}" > "${MM9_REGIONS_TABLE_COMBINED}"
    for table in ${MM9_REGIONS_TABLES[*]}
    do
    rm "${MURINE_REGIONS_DIR}/${table}"
    done
    zcat "${MM9_REGIONS_TABLE_COMBINED}"| awk '{OFS ="\t"} (($13 ~/Alu/||$13 ~/^B2/) && $12 == "SINE"){print $6,$7,$8}' | ${BEDTOOLS_PATH} sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin| gzip > "${MURINE_REGIONS_DIR}/${MM9_REGIONS_FILE}"
    rm "${MURINE_REGIONS_DIR}/${MM9_REGIONS_TABLE_COMBINED}"
    echo "Done Processing MM9 B1 and B2 Repeats Table ${MM9_REGIONS_TABLE_FILES}"
  else
    echo "Failed to Process MM9 Files (cd command fails)"
  fi

  # Generate Indexes
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of MM10 B1 and B2 Repeats ${MM9_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${MURINE_REGIONS_DIR}/${MM9_REGIONS_FILE}" -g "${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA}" \
      -o "${MURINE_REGIONS_DIR}/${MM9_GENOME_FASTA}.${MM9_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # SNPs
  echo "Downloading MM9 Genomic SNPs Table ${MM9_FTP_URL}${MM9_SNPS_TABLE_FILE}"
  wget "${MM9_FTP_URL}${MM9_SNPS_TABLE_FILE}"  --directory-prefix="${MURINE_SNPS_DIR}"
  echo "Processing MM9 Genomic SNPs Table ${MM9_SNPS_TABLE_FILE}"
  zcat "${MURINE_SNPS_DIR}/${MM9_SNPS_TABLE_FILE}" | awk '{OFS ="\t"}($11=="genomic") {print $2,$3,$4,$7,$9,$10,$16,"NA"}'| gzip > "${MURINE_SNPS_DIR}/${MM9_SNPS_FILE}"
  rm "${MURINE_SNPS_DIR}/${MM9_SNPS_TABLE_FILE}"
  echo "Done Processing MM9  Genomic SNPs Table ${MM9_SNPS_TABLE_FILE}"

  # RefSeq
  echo "Downloading MM9 RefSeq Table ${MM9_FTP_URL}${MM9_REFSEQ_TABLE_FILE}"
  wget "${MM9_FTP_URL}${MM9_REFSEQ_TABLE_FILE}"  --directory-prefix="${MURINE_REFSEQ_DIR}"
  echo "Processing MM9 RefSeq Table ${MM9_REFSEQ_TABLE_FILE}"
  zcat "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$5,$6,$2,$13,$4,$10,$11}' |gzip > "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_FILE}"

  # --- CDS Regions
  zcat "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_FILE}"| cut -f1,7,8 \
   | awk -F ["\t",] '{OFS="\t"; for (i=2; i<=(NF-1)/2 ; i++) {j=i+(NF-1)/2; print $1,$i,$j }}'| gzip > \
   "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}.Exons.bed"
  zcat "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_TABLE_FILE}"| awk '{OFS ="\t"} {print $3,$7,$8}' | "${BEDTOOLS_PATH}" \
  subtract -a "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  "${BEDTOOLS_PATH}" subtract -a "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}.Exons.bed" -b stdin | \
  ${BEDTOOLS_PATH} sort -i stdin| ${BEDTOOLS_PATH} merge -i stdin | gzip > "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}"

  rm "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_TABLE_FILE}" "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}.Exons.bed"
  echo "Done Processing MM9 RefSeq Table ${MM9_REFSEQ_TABLE_FILE}"

  # --- Generate Indexes for CDS
  if [ "${DONT_GENERATE_GENOME_INDEXES}" = false ]
  then
    echo "Attempting to Create Genome Index of MM9 CDS ${MM9_CDS_REGIONS_FILE}"
    "${JAVA_HOME}/bin/java" -jar "${LIB_DIR}/EditingIndexJavaUtils.jar" GenerateIndex -i \
      "${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}" -g "${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA}" \
      -o "${MURINE_REGIONS_DIR}/${MM9_GENOME_FASTA}.${MM9_CDS_REGIONS_FILE}.GenomeIndex.jsd" -b "${BEDTOOLS_PATH}"
  fi

  # Genes Expression
  echo "Warning: Murine Gene Expression was derived from ENCODE MM9 table from 2013! (Newer Data was not available)"
  echo "Processing MM10Genes Expression File ${MURINE_GENE_EXPRESSION_FILE} For MM9"
  ${PYTHON27_PATH} "${DEV_ROOT}/make/compileMouseEncodeGeneExpression.py" "${MURINE_GENES_EXPRESSION_DIR}/${MURINE_GENE_EXPRESSION_FOLDER}"  "${MURINE_GENES_EXPRESSION_DIR}/${MM9_GENES_EXPRESSION_FILE}" "${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_FILE}"
  rm -r "${MURINE_GENES_EXPRESSION_DIR:?}/${MURINE_GENE_EXPRESSION_FOLDER:?}"
  echo "Done Processing MM9 Genes Expression From Tables ${MURINE_GENE_EXPRESSION_FILE}"
else
  echo "Info: Downloading Resources is Disabled!"
fi

#---------------------------------------------------------------------------
# Create INI File
#---------------------------------------------------------------------------
if [ "${DONT_WRITE}" = false ]
then
  {
  echo "[DEFAULT]"
  echo "ResourcesDir = ${RESOURCES_DIR}"
  echo "BEDToolsPath = ${BEDTOOLS_PATH}"
  echo "SAMToolsPath = ${SAMTOOLS_PATH}"
  echo "JavaHome = ${JAVA_HOME}"
  echo "BAMUtilsPath = ${BAM_UTILS_PATH}"
  echo "EIJavaUtils = ${LIB_DIR}/EditingIndexJavaUtils.jar"

  echo "[hg38]"
  echo "Genome =  ${HUMAN_GENOME_DIR}/${HG38_GENOME_FASTA}"
  echo "RERegions = ${HUMAN_REGIONS_DIR}/${HG38_REGIONS_FILE}"
  echo "CDSRegions = ${HUMAN_REGIONS_DIR}/${HG38_CDS_REGIONS_FILE}"
  echo "CDSRegionsRefSeqAll = ${HUMAN_REGIONS_DIR}/${HG38_CDS_REFSEQ_ALL_REGIONS_FILE}"
  echo "SNPs = ${HUMAN_SNPS_DIR}/${HG38_SNPS_FILE}"
  echo "RefSeq = ${HUMAN_REFSEQ_DIR}/${HG38_REFSEQ_FILE}"
  echo "RefSeqAll = ${HUMAN_REFSEQ_DIR}/${HG38_ALL_REFSEQ_FILE}"
  echo "GenesExpression = ${HUMAN_GENES_EXPRESSION_DIR}/${HG38_GENES_EXPRESSION_FILE}"
  echo ""

  echo "[hg19]"
  echo "Genome = ${HUMAN_GENOME_DIR}/${HG19_GENOME_FASTA}"
  echo "RERegions = ${HUMAN_REGIONS_DIR}/${HG19_REGIONS_FILE}"
  echo "CDSRegions = ${HUMAN_REGIONS_DIR}/${HG19_CDS_REGIONS_FILE}"
  echo "CDSRegionsRefSeqAll = ${HUMAN_REGIONS_DIR}/${HG19_CDS_REFSEQ_ALL_REGIONS_FILE}"
  echo "SNPs = ${HUMAN_SNPS_DIR}/${HG19_SNPS_FILE}"
  echo "RefSeq = ${HUMAN_REFSEQ_DIR}/${HG19_REFSEQ_FILE}"
  echo "RefSeqAll = ${HUMAN_REFSEQ_DIR}/${HG19_ALL_REFSEQ_FILE}"
  echo "GenesExpression = ${HUMAN_GENES_EXPRESSION_DIR}/${HG19_GENES_EXPRESSION_FILE}"
  echo ""

  echo "[mm10]"
  echo "Genome =  ${MURINE_GENOME_DIR}/${MM10_GENOME_FASTA}"
  echo "RERegions = ${MURINE_REGIONS_DIR}/${MM10_REGIONS_FILE}"
  echo "CDSRegions = ${MURINE_REGIONS_DIR}/${MM10_CDS_REGIONS_FILE}"
  echo "CDSRegionsRefSeqAll = ${MURINE_REGIONS_DIR}/${MM10_CDS_REFSEQ_ALL_REGIONS_FILE}"
  echo "SNPs = ${MURINE_SNPS_DIR}/${MM10_SNPS_FILE}"
  echo "RefSeq = ${MURINE_REFSEQ_DIR}/${MM10_REFSEQ_FILE}"
  echo "RefSeqAll = ${MURINE_REFSEQ_DIR}/${MM10_ALL_REFSEQ_FILE}"
  echo "GenesExpression = ${MURINE_GENES_EXPRESSION_DIR}/${MM10_GENES_EXPRESSION_FILE}"
  echo ""

  echo "[mm9]"
  echo "Genome = ${MURINE_GENOME_DIR}/${MM9_GENOME_FASTA}"
  echo "RERegions = ${MURINE_REGIONS_DIR}/${MM9_REGIONS_FILE}"
  echo "CDSRegions = ${MURINE_REGIONS_DIR}/${MM9_CDS_REGIONS_FILE}"
  echo "SNPs = ${MURINE_SNPS_DIR}/${MM9_SNPS_FILE}"
  echo "RefSeq = ${MURINE_REFSEQ_DIR}/${MM9_REFSEQ_FILE}"
  echo "GenesExpression = ${MURINE_GENES_EXPRESSION_DIR}/${MM9_GENES_EXPRESSION_FILE}"
  echo ""
   } > "${DBS_PATHS_INI}"

else
  echo "Info: Writing Resources.ini file is Disabled!"
fi