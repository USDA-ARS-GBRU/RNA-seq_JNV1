## RNA-seq pipeline using kallisto and DESeq2

### Justin Vaughn; 11 March 2018

### Main pipeline
 
In order: 

0. Each sample should have its own subdirectory containing the reads derived from that sample

1. **concatenate.pl**.  The script will contatenate reads across lanes if needed and if their syntax matches that used in concatenate.pl.  Each sample name/subdirectory name is given in @list and the root directory is giving in $mainDir.  $readLength also needs hardcoding.  concatenate.pl also does hard trimming of the last base and produces quality graphs.  For RNA-seq I usually don't trim unless I see a weird graph, but trimmomatic would probably be good to run.

2. Run kallisto indexing on the transcriptome to be aligned to.

3. **runKallisto.pl**: Simply runs kallisto on all samples.  Note kallisto location is hardcoded in the script and needs to be able to find the indexed transcriptome. Each sample name/subdirectory name is given in @list and the root directory is giving in $mainDir.

4. **createCountMatrix.pl**: Compiles kallisto counts across samples into a single matrix. Each sample name/subdirectory name is given in @list and the root directory is giving in $mainDir.

5.  Create experimental deisign matrix in tab-delimited format for DESeq2.  This can bedcone in excel.  First element in the header should be "sampleID", but then the rest are arbitrary, although they must match what you use in the DESeq2 script below.

6. **runDESeq2_transcriptomeGenesUsingInteractionPVal.R**: Identifies genes across the entire experiment for which a specified factor is significant (sush as condition).  To do this, a model with the factor is comared with the same model without this factor (the reduced model).  THis script also produces numerous clustering, PCA, and top gene graphs.\
*AND/OR*\
**runDESeq2_transcriptomeGenesContrastGroups.R**: An alternative to the above script, if one only wants to look at differences in expression between conditions at one time point, for example.

7. **keggAnalysis.R**:  Filters genes from a DESeq2 output and looks for enrichment in a particular kegg pathway.  I usually use vary liberal threshold here for gene filtering since the kegg datasets are generally pretty sparce. Appropriate kegg dataset must be identified and specific script using keggseq directly in R. 

## Plotting scripts

**keggAnalysisPlotSinglePathway.R**: For plotting a particular kegg pathway with differentially expressed genes color coded.

**plotASingleGene.R**: Plots time series expression curve for specific genes.


