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

baseCommand: [PolyATrimmer]


inputs:
  input:
    doc: |
      The input SAM or BAM file to analyze.  Required.
    type: File
    inputBinding:
      prefix: INPUT=
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
            return inputs.input.nameroot + ".polyA_filtered.bam";
          }
          else {
            return inputs.output;
          }
        }
  output_summary:
    doc: |
      The output summary statistics  Default value: null.
    default: ""
    type: string
    inputBinding:
      prefix: OUTPUT_SUMMARY=
      valueFrom: |
        ${
          if (inputs.output_summary == "") {
            return inputs.input.nameroot + ".polyA_filtered.summary";
          }
          else {
            return inputs.output_summary;
          }
        }
  num_bases:
    doc: |
      How many bases at the begining of the sequence must match before
      trimming occurs. Default value: 6. This option can be set to 'null'
      to clear the default value.
    default: 6
    type: int
    inputBinding:
      prefix: NUM_BASES=
  mismatches:
    doc: |
      How many mismatches are acceptable in the sequence.
      Default value: 0. This option can be set to 'null' to clear
      the default value.
    default: 0
    type: int
    inputBinding:
      prefix: MISMATCHES=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".polyA_filtered.bam";
          }
          else {
            return inputs.output;
          }
        }
  output_summary_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_summary == "") {
            return inputs.input.nameroot + ".polyA_filtered.summary";
          }
          else {
            return inputs.input;
          }
        }