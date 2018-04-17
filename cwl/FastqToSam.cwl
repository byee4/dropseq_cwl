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

baseCommand: [picard, FastqToSam]

arguments:
  - valueFrom: -Xmx4g
    position: -1

inputs:
  fastq:
    doc: |
      Input fastq file (optionally gzipped) for
      single end data, or first read in paired end
      data.  Required.
    type: File
    inputBinding:
      prefix: F1=
  fastq2:
    doc: |
      Input fastq file (optionally gzipped) for
      the second read of paired end data.  Default
      value: null.
    type: File?
    inputBinding:
      prefix: F2=
  output:
    doc: |
      Output SAM/BAM file.   Required.
    type: string
    inputBinding:
      prefix: O=
  sample_name:
    doc: |
      Sample name to insert into the read group header  Required.
    type: string
    inputBinding:
      prefix: SM=
  sort_order:
    doc: |
      The sort order for the output sam/bam file.
      Default value: queryname. This option can be
      set to 'null' to clear the default value.
      Possible values: {unsorted, queryname,
      coordinate, duplicate, unknown}
    default: "queryname"
    type: string
    inputBinding:
      prefix: SO=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: "$(inputs.output)"