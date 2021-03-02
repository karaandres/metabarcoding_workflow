# metabarcoding_workflow

### This repository contains my general workflow used to analyze eDNA metabarcoding data from Illumina sequences, starting with a set of Illumina-sequenced paired-end fastq files that have been demultiplexed by sample and ending with an ASV table of filtered, high quality ASVs per site. Additional optional steps include assigning taxonomic information to the ASVs and/or clustering the ASVs according to percent similarity. I start the workflow at the command line and migrate to R once the data is in a manageable format. The steps are as follows: 

   1. Download data files from sequencing facility
      - The Cornell Biotechnology Resource Center (BRC) will return Illumina sequencing data via an email containing the run ID, sequencing platform, order number, software version, and sample names. 
      - The sequence read files are in fastq format and can be downloaded to your home directory in the BioHPC Cloud using the following steps:
        * Download the script attached to the email (download.sh)
        * Login to your home directory `ssh kja68@*************` and enter your password
        * Create a directory where you want the files stored `mkdir new_diretory` and cd to this directory `cd /new_directory/`
        * Copy the download.sh script to this directory using a file transfer software such as [Cyberduck](https://cyberduck.io/download/)
        * Run the script `sh ./download.sh`
      
   2. Check sequence quality
      - Reserve BioHPC workstation, log in, create and change to working directory `mkdir /workdir/kja68`, `cd /workdir/kja68`
      - Copy raw sequence files from home directory to working directory ` cp /home/kja68/raw_sequence_files/*.gz  /workdir/kja68/` 
      - Run [fastqc_multiqc.sh](fastqc_multiqc.sh) (see BioHPC software guides: [fastqc](https://biohpc.cornell.edu/lab/userguide.aspx?a=software&i=74#c), [multiqc](https://biohpc.cornell.edu/lab/userguide.aspx?a=software&i=323))
      - (Optional) Display the multiqc_summary.html (or any .html) on GitHub using [these steps](https://www.finex.co/how-to-display-html-in-github/)
   
   3. Remove primers and/or adaptors
      - If primers are at the start of your reads and are a constant length, you can use the trimLeft = c(FWD_PRIMER_LEN, REV_PRIMER_LEN) argument of dada2’s filtering functions to remove the primers (see step 4).  
      - If you added heterogeneity spacers before the primers to increase the complexity of your samples for sequencing, you can remove them using the [Trimming_HS_Metagenomics](https://github.com/noushing/Trimming_HS_Metagenomics) code. Then proceed with removing the primers as above.
        * example: [metabarcoding_workflow_trimming_spacers.txt](metabarcoding_workflow_trimming_spacers.txt)
      - If sequencing extends beyond the length of the amplicon, the adapter and primer sequences will also be found on the 3’ end of the read, and you will need to remove them (see [this page for a good explanation](https://support.illumina.com/bulletins/2016/04/adapter-trimming-why-are-adapter-sequences-trimmed-from-only-the--ends-of-reads.html)). It may be a good idea to trim adapter sequences regardless of the size of your amplicon. 
        * [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) is useful for trimming adapters
        * example: copy [metabarcoding_workflow_trimmomatic.sh](metabarcoding_workflow_trimmomatic.sh) to directory with files, run `./trimmomatic_loop.sh`
        * This will loop through all forward and reverse reads and produce output files of format *_paired.fastq.gz where both reads survived the processing. There are the files that will be used for input into DADA2 pipeline
   
   4. Filter, trim, merge pairs, remove chimeras [DADA2 pipeline](https://benjjneb.github.io/dada2/index.html)
      - DADA2 requires R, but since we are still working with large files, I run R from the command line to complete this step
      - example: [metabarcoding_workflow_dada2.txt](metabarcoding_workflow_dada2.txt)
      - the output file `uniqueSeqs.nochim.fasta` will be used for taxonomic assignment
   
   5. Taxonomic assignment (BLAST)
      - To get species-level information, copy the nucleotide and taxonomic databases into your directory and run blastn. Output formats are customizable depending on what information you need (for more information on output formats, see `blastn -help` then look for the field called `outfmt`)
      - To get higher taxonomic info based on taxids, download [tax_trace.pl](https://github.com/theo-allnutt-bioinformatics/scripts/blob/master/tax_trace.pl) and the [taxonomy database](https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/) from NCBI and copy these into your directory
      - example: [metabarcoding_workflow_blast.txt](metabarcoding_workflow_blast.txt)
      - If you have sequences that are not yet on NCBI (e.g. if you Sanger sequenced tissues to add to the reference database) you can run a local blast. Example: [local_blast.txt](local_blast.txt) 
   
   6. Data filtering
   
   7. Cluster sequences
