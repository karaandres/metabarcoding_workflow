# metabarcoding_workflow

### This repository contains the general workflow used to analyze eDNA metabarcoding data from Illumina sequences, starting with a set of Illumina-sequenced paired-end fastq files that have been demultiplexed by sample and ending with an ASV table of filtered, high quality ASVs per site. Additional optional steps include assigning taxonomic information to the ASVs and/or clustering the ASVs according to percent similarity. The steps are as follows: 
   1. Download data files from sequencing facility
      - The Cornell Biotechnology Resource Center (BRC) will return Illumina sequencing data via an email containing the run ID, sequencing platform, order number, software version, and sample names. 
      - The sequence read files are in fastq format and can be downloaded to your home directory in the BioHPC Cloud using the following steps:
        * Download the script attached to the email (download.sh)
        * Login to your home directory `ssh kja68@cbsulogin3.tc.cornell.edu` and enter your password
        * Create a directory where you want the files stored `mkdir new_diretory` and cd to this directory `cd /new_directory/`
        * Copy the download.sh script to this directory using a file transfer software such as [Cyberduck](https://cyberduck.io/download/)
        * Run the script `sh ./download.sh`
   
   2. Check sequence quality
      - Reserve BioHPC workstation, log in (e.g. `ssh kja68@cbsulm04.biohpc.cornell.edu`), create and change to working directory `mkdir /workdir/kja68`, `cd /workdir/kja68`
      - Copy raw sequence files from home directory to working directory ` cp /home/kja68/raw_sequence_files/*.gz  /workdir/kja68/` 
      - Run [fastqc_multiqc.sh](fastqc_multiqc.sh) (see BioHPC software guides: [fastqc](https://biohpc.cornell.edu/lab/userguide.aspx?a=software&i=74#c), [multiqc](https://biohpc.cornell.edu/lab/userguide.aspx?a=software&i=323))
      - (Optional) Display the multiqc_summary.html on GitHub using [these steps](https://www.finex.co/how-to-display-html-in-github/)
   
   3. Remove barcodes and adaptors
      - You need to remove the adaptors if the sequencing (see [this page for a good explanation](https://support.illumina.com/bulletins/2016/04/adapter-trimming-why-are-adapter-sequences-trimmed-from-only-the--ends-of-reads.html))
   4. Filter, trim, merge pairs, remove chimeras (DADA2 pipeline)
   5. Taxonomic assignment (BLAST)
   6. Data filtering
   7. Cluster sequences
