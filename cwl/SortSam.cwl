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

baseCommand: [picard, SortSam]

arguments:
  - valueFrom: -Xmx4g
    position: -1

inputs:
  input:
    doc: |
      Input SAM/BAM file to extract reads from  Required.
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
            return inputs.input.nameroot + ".namesorted.bam";
          }
          else {
            return inputs.output;
          }
        }
  sort_order:
    doc: |
      Sort order of output file. Required. Possible values
        queryname, coordinate, duplicate.
    type: string
    inputBinding:
      prefix: SORT_ORDER=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".namesorted.bam";
          }
          else {
            return inputs.output;
          }
        }