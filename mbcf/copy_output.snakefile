# vim: syntax=python tabstop=4 expandtab
# coding: utf-8
import sys

VIPER_DIR=os.environ.get("VIPER_DIR")

if not VIPER_DIR:
    print("Execute the snakefile as: VIPER_DIR=/path/to/copy/dir_name snakemake -s copy_output.snakefile")
    sys.exit()

rule target:
    input:
        "{VIPER_DIR}/alignment/bam/", "{VIPER_DIR}/alignment/bigwig/", "{VIPER_DIR}/diffexp/", "{VIPER_DIR}/expression/", "{VIPER_DIR}/QC/",  "{VIPER_DIR}/SNP/", "{VIPER_DIR}/Summary/plots/"

rule copy_fastqc:
    output:
        fastqc_dir="RNASeq/FastQC/"
    shell: 
        "find fastqc/before_filtering/ -name \"[0-9]*html\" -exec cp -t {output.fastqc_dir} {{}} \;"

rule copy_alignment_bam:
    output:
        bam_dir="{VIPER_DIR}/alignment/bam/"
    shell:
        "find analysis/STAR/ -type f -name \"*\.sorted\.ba*\" -exec cp -t {output.bam_dir} {{}} \;"
        " && cp analysis/STAR/STAR_Align_Report.csv {output.align_dir}/Alignment_Report.csv"
        " && cp analysis/STAR/STAR_Align_Report.png {output.align_dir}/Alignment_Report.png"


rule copy_alignment_bw:
    output:
        bw_dir="{VIPER_DIR}/alignment/bigwig/"
    shell:
        "find analysis/bam2bw/ -type f -name \"*\.bw\" -exec cp -t {output.big_wig} {{}} \;"


rule copy_diffexp:
    output:
        de_dir="{VIPER_DIR}/diffexp/"
    shell:
        "cp -rf analysis/diffexp/* {output.de_dir}"


rule copy_cufflinks_exp:
    output:
        cuff_dir="{VIPER_DIR}/expression/"
    shell:
        "cp -rf analysis/cufflinks {output.cuff_dir}"
        " && cp analysis/cufflinks/Cuff_Gene_Counts.csv {output.cuff_dir}/Normalized_FPKM_Gene_Counts.csv"
        " && cp analysis/STAR/STAR_Gene_Counts.csv {output.cuff_dir}/Raw_Gene_Counts.csv"


rule copy_RSeQC:
    output:
        qc_dir="{VIPER_DIR}/QC/"
    shell:
        "cp -rf analysis/RSeQC/* {output.qc_dir}"


rule copy_snp:
    output:
        snp_dir="{VIPER_DIR}/SNP/"
    shell:
        "cp -rf analysis/snp/* {output.snp_dir}"


rule copy_summary:
    output:
        summary_dir="{VIPER_DIR}/Summary/",
        plots_dir="{VIPER_DIR}/Summary/plots/"
    shell:
        "find analysis/ -type f -name \"*.png\" -exec cp -t {output.plots_dir} {{}} \;"
        " && cp report.html $(basename {VIPER_DIR})_report.html"  
