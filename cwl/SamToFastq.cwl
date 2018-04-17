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

baseCommand: [picard, SamToFastq]

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
  fastq:
    doc: |
      Output FASTQ file (single-end fastq or,
      if paired, first end of the pair FASTQ).
    default: ""
    type: string
    inputBinding:
      prefix: FASTQ=
      valueFrom: |
        ${
          if (inputs.fastq == "") {
            return inputs.input.nameroot + ".fastq";
          }
          else {
            return inputs.fastq;
          }
        }
outputs:
  output_fastq_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.fastq == "") {
            return inputs.input.nameroot + ".fastq";
          }
          else {
            return inputs.fastq;
          }
        }