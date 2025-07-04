# Isolate Assembly and AMR Characterization Pipeline

This Nextflow pipeline performs isolate genome assembly, quality control, functional annotation, and antimicrobial resistance (AMR) gene prediction from Whole Genome Sequencing (WGS) data. It is tailored for metagenomic or isolate samples and uses a combination of well-established bioinformatics tools.

---

## 🧬 Workflow Overview

The pipeline includes the following major steps:

1. Quality Control (FastQC, MultiQC, Fastp)
2. Genome Assembly (Megahit)
3. Gene Prediction and Functional Annotation (Prokka, EggNOG-mapper)
4. Biosynthetic Gene Cluster Identification (antiSMASH)
5. AMR Gene Prediction (AMRFinderPlus)
6. Output aggregation and formatting

---

## 🔧 Tools Used

| Tool            | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| **FastQC**      | Quality control of raw sequencing reads                                 |
| **MultiQC**     | Aggregation of quality control reports                                  |
| **Fastp**       | Read filtering, trimming, and quality correction                        |
| **Megahit**     | De novo metagenome assembly of filtered reads                           |
| **Prokka**      | Rapid annotation of prokaryotic genomes                                 |
| **EggNOG-mapper** | Functional annotation using orthology assignments                      |
| **AMRFinderPlus** | AMR gene prediction using curated NCBI databases                       |
| **antiSMASH**   | Detection of biosynthetic gene clusters (secondary metabolites)         |

---

## 📂 Project Structure

```
.
├── main.nf                  # Main Nextflow pipeline script
├── nextflow.config          # Configuration file with parameter defaults
├── modules/                 # Individual process modules (FastQC, Megahit, etc.)
├── input-seqs/              # Input FASTQ files (paired-end reads)
│   └── Sample1/
│       ├── Sample1_R1.fastq.gz
│       └── Sample1_R2.fastq.gz
├── mapping.csv              # Sample metadata
├── StudyDetails.json        # Study metadata
├── pipeline-run/            # Output directory
├── work/                    # Nextflow intermediate work files
└── README.md                # You're here
```

---

## ▶️ How to Run

### Step 1: Install Dependencies

Make sure the following are installed:
- [Nextflow](https://www.nextflow.io/)
- Docker or Singularity (recommended) or Conda for reproducible environments
- Tool binaries in `PATH` (if not using containers)

### Step 2: Clone and Prepare Input

```bash
git clone https://github.com/YOUR_USERNAME/isolate-assembly-characterisation-and-AMR-detection.git
cd isolate-assembly-characterisation-and-AMR-detection
```

Ensure you have:

- Sample FASTQ files in `input-seqs/Sample*/`
- `mapping.csv` with sample names and descriptions
- `StudyDetails.json` with study metadata

### Step 3: Run the Pipeline

```bash
nextflow run main.nf 
```

You can also specify alternative input/output directories:

```bash
nextflow run main.nf --inputDir /path/to/data --outputDir /path/to/results
```

---

## 📄 Input File Formats

### `mapping.csv`

```csv
sample_id,description
Sample1,Test sample for AMR detection
Sample2,Test sample for AMR detection
```

### `StudyDetails.json`

```json
{
  "study_id": "TEST001",
  "description": "Minimal test case for the AMR detection pipeline",
  "date": "2025-07-02",
  "organism": "mixed metagenome",
  "error-message": ""
}
```

---

## 📤 Outputs

The pipeline generates:

- QC reports in `pipeline-run/fastqc/`
- Assemblies in `pipeline-run/megahit/`
- Annotations in `pipeline-run/prokka/`, `pipeline-run/emapper/`, and `pipeline-run/antismash/`
- AMR results in `pipeline-run/amrfinderplus/`
- Summary and intermediate files in `pipeline-run/` and `work/`

Each process creates subdirectories for each sample for traceability and clarity.

---

## 🔍 Tool Descriptions

- **FastQC**: Analyzes per-base quality scores, GC content, and overrepresented sequences in FASTQ files.
- **MultiQC**: Aggregates FastQC (and other) reports into a single HTML summary.
- **Fastp**: High-speed preprocessor for FASTQ data. Trims low-quality bases and adapters.
- **Megahit**: Fast and memory-efficient assembler optimized for large metagenomes and isolates.
- **Prokka**: Annotates genes, rRNAs, and other genomic features in microbial genomes.
- **EggNOG-mapper**: Assigns functional information based on orthologous groups from the EggNOG database.
- **antiSMASH**: Identifies secondary metabolite biosynthetic gene clusters, like those producing antibiotics.
- **AMRFinderPlus**: Uses curated NCBI AMR gene databases for predicting resistance genes from protein or nucleotide sequences.

---

## 🧪 Example Dataset

A small test dataset is available for download:

[Download Sample Input Dataset](sandbox:/mnt/data/metagenome-amr-pipeline-test-inputs.zip)

---

## ✨ License and Acknowledgements

This pipeline uses publicly available tools and is released under the MIT license. Please cite the original tools used when publishing results from this workflow.

---

## 📬 Contact

For questions, feedback, or contributions, feel free to open an issue .
