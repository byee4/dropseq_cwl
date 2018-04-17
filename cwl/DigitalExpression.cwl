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

baseCommand: [DigitalExpression]


inputs:
  input:
    doc: |
      The input SAM or BAM file to analyze  Required.
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
            return inputs.input.nameroot + ".dge.txt.gz";
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
            return inputs.input.nameroot + ".dge.summary.txt";
          }
          else {
            return inputs.output_summary;
          }
        }
  num_core_barcodes:
    doc: |
      How many mismatches are acceptable in the sequence.
      Default value: null. This option can be set to 'null' to clear
      the default value.
    type: int
    inputBinding:
      prefix: NUM_CORE_BARCODES=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".dge.txt.gz";
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
            return inputs.input.nameroot + ".dge.summary.txt";
          }
          else {
            return inputs.output_summary;
          }
        }