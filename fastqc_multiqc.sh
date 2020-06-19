#!/bin/bash
# Run fastqc and multiqc to check the quality of Illumina sequences

fastqc /workdir/kja68/*.gz
export LC_ALL=en_US.UTF-8
export PATH=/programs/miniconda3/bin:$PATH
source activate multiqc
multiqc /workdir/kja68/
conda deactivate
