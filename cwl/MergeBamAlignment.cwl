#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 16
    ramMin: 32000
    # tmpdirMin: 4000
    # outdirMin: 4000

baseCommand: [picard, MergeBamAlignment]

arguments:
  - valueFrom: -Xmx4g
    position: -1

inputs:
  reference_sequence:
    doc: |
      Reference sequence file.  Required.
    type: File
    secondaryFiles:
      - .dict
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
  aligned_bam:
    doc: |
      The input SAM or BAM file to analyze.  Required.
    type: File
    inputBinding:
      prefix: ALIGNED=
  unmapped_bam:
    doc: |
      The input SAM or BAM file to analyze.  Required.
    type: File
    inputBinding:
      prefix: UNMAPPED_BAM=
  include_secondary_alignments:
    doc: |
      If false, do not write secondary alignments to output.
    default: "false"
    type: string
    inputBinding:
      prefix: INCLUDE_SECONDARY_ALIGNMENTS=
  paired_run:
    doc: |
      This argument is ignored and will be removed.  Default value: false.
    default: "false"
    type: string
    inputBinding:
      prefix: PAIRED_RUN=
  output:
    doc: |
      The output BAM file  Required.
    default: ""
    type: string
    inputBinding:
      prefix: OUTPUT=
      valueFrom: |
        ${
          if (inputs.output == "") {
            return inputs.aligned_bam.nameroot + ".merged.bam";
          }
          else {
            return inputs.output;
          }
        }


outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.aligned_bam.nameroot + ".merged.bam";
          }
          else {
            return inputs.output;
          }
        }