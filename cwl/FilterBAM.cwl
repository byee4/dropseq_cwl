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

baseCommand: [FilterBAM]


inputs:
  input:
    doc: |
      The input SAM or BAM file to analyze.  Required.
    type: File
    inputBinding:
      prefix: INPUT=
  output:
    doc: |
      Output report  Required.
    default: ""
    type: string
    inputBinding:
      prefix: OUTPUT=
      valueFrom: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".filtered.bam";
          }
          else {
            return inputs.output;
          }
        }
  tag_reject:
    doc: |
      Reject reads that have these tags set with any value.
      Can be set multiple times. Default value: null.
      This option may be specified 0 or more times.
    default: "XQ"
    type: string
    inputBinding:
      prefix: TAG_REJECT=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".filtered.bam";
          }
          else {
            return inputs.output;
          }
        }