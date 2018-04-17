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

baseCommand: [DetectBeadSynthesisErrors]

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
            return inputs.input.nameroot + ".cleaned.bam";
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
      prefix: SUMMARY=
      valueFrom: |
        ${
          if (inputs.output_summary == "") {
            return inputs.input.nameroot + ".synthesis_summary";
          }
          else {
            return inputs.output_summary;
          }
        }
  output_stats:
    doc: |
      Output of detailed information on each cell barcode analyzed.
    default: ""
    type: string
    inputBinding:
      prefix: OUTPUT_STATS=
      valueFrom: |
        ${
          if (inputs.output_stats == "") {
            return inputs.input.nameroot + ".synthesis_stats";
          }
          else {
            return inputs.output_stats;
          }
        }
  num_barcodes:
    doc: |
      How many mismatches are acceptable in the sequence.
      Default value: null. This option can be set to 'null' to clear
      the default value.
    type: int
    inputBinding:
      prefix: NUM_BARCODES=
  primer_sequence:
    doc: |
      The sequence of the primer.  Default value: null.
    type: string
    inputBinding:
      prefix: PRIMER_SEQUENCE=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".cleaned.bam";
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
            return inputs.input.nameroot + ".synthesis_summary";
          }
          else {
            return inputs.output_summary;
          }
        }
  output_stats_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_stats == "") {
            return inputs.input.nameroot + ".synthesis_stats";
          }
          else {
            return inputs.output_stats;
          }
        }