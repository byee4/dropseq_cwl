# dropseq_cwl
cwl workflow wrapping McCarroll lab dropseq analysis as described [here](http://mccarrolllab.com/wp-content/uploads/2016/03/Drop-seqAlignmentCookbookv1.2Jan2016.pdf):

# Installation:
Install prerequisites (this creates an Anaconda environment, downloads DropSeqTools, and installs TOIL/java/picard/STAR):
```source create_environment_dropseq-cwl.sh```

Ensure that the following directories are in your $PATH:
- bin/Drop-seq-tools
- bin/
- cwl/
- wf/

### On Local machine:

There is a bash script that wraps this workflow by doing the following:
- conveniently sets temporary/output directories
- generates logfiles
- runs the workflow using either cwl-runner or, if applicable, TOIL on either single or a cluster of machines.

By default, ```wf/dropseq-runner``` is set to 'cwltorq', which is set up to run PBS jobs on TSCC.

If not on TSCC, modify this ```wf/dropseq-runner``` file by changing the following line:

```CWLRUNNER=cwltorq # either: cwltool cwltoil or cwltorq```

to:

```CWLRUNNER=cwltool # either: cwltool cwltoil or cwltorq``` (runs workflow with cwl-runner)
```CWLRUNNER=cwltoil # either: cwltool cwltoil or cwltorq``` (runs workflow with singleMachine TOIL)

### On TSCC:

```module load dropseqtools```

# Running the workflow:

- Visit this page and fill out the required fields: http://byee4.github.io/dropseq.html
- Copy and paste the contents of that form into a file (such as ```samples.json```), preferably inside a scratch directory.
- Make this file executable (```chmod +x samples.json```)
- Assuming the above directories can be found on your path, you can run the workflow using the json file (```./samples.json```)

# Outputs:
Here are example outputs for a single sample:

| File name (run_id: r01, sample_id: s01)                                                                                                       | Description of output                                                      |
|-----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| r01_s01.sam                                                                                                                                   | Unaligned OUTPUT from picard FastqToSam                                    |
| r01_s01.tagged1-12.bam                                                                                                                        | Unaligned tagged cell barcodes OUTPUT from TagBamWithReadSequenceExtended  |
| r01_s01.tagged1-12.summary                                                                                                                    | Unaligned tagged cell barcodes SUMMARY from TagBamWithReadSequenceExtended |
| r01_s01.tagged1-12.tagged13-20.bam                                                                                                            | Unaligned tagged UMI barcodes OUTPUT from TagBamWithReadSequenceExtended   |
| r01_s01.tagged1-12.tagged13-20.summary                                                                                                        | Unaligned tagged UMI barcodes SUMMARY from TagBamWithReadSequenceExtended  |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.bam                                                                                     | Unaligned OUTPUT from TrimStartingSequence                                 |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.summary                                                                                 | Unaligned OUTPUT_SUMMARY from TrimStartingSequence                         |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.bam                                                                      | Unaligned OUTPUT from PolyATrimmer                                         |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.summary                                                                  | Unaligned OUTPUT_SUMMARY from PolyATrimmer                                 |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARLog.out                                                              | Aligned STAR log file                                                      |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARLog.final.out                                                        | Aligned STAR final summary file                                            |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARUnmapped.out.mate1                                                   | Unaligned STAR sequences                                                   |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.bam                                                      | Aligned STAR file                                                          |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.bam                                           | OUTPUT from picard SortSam                                                 |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.bam                                    | OUTPUT from picard MergeBamAlignment                                       |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.bam                     | OUTPUT from TagReadWithGeneExon                                            |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.synthesis_stats         | OUTPUT_STATS from DetectBeadSynthesisErrors                                |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.synthesis_summary       | SUMMARY from DetectBeadSynthesisErrors                                     |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.cleaned.bam             | OUTPUT from DetectBeadSynthesisErrors                                      |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.cleaned.dge.summary.txt | SUMMARY from DigitalExpression                                             |
| r01_s01.tagged1-12.tagged13-20.filtered.trimmed_smart.polyA_filtered.STARAligned.out.namesorted.merged.TaggedGeneExon.cleaned.dge.txt.gz      | OUTPUT from DigitalExpression                                              |

# References:

Macosko, Evan Z., et al. "Highly parallel genome-wide expression profiling of individual cells using nanoliter droplets." Cell 161.5 (2015): 1202-1214.

