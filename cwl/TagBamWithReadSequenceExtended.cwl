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

baseCommand: [TagBamWithReadSequenceExtended]


inputs:
  input:
    doc: |
      The input SAM or BAM file to analyze.  Required.
    type: File
    inputBinding:
      prefix: INPUT=
  output:
    doc: |
      Output bam  Required.
    default: ""
    type: string
    inputBinding:
      prefix: OUTPUT=
      valueFrom: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".tagged" + inputs.base_range + ".bam";
          }
          else {
            return inputs.output;
          }
        }
  barcoded_read:
    doc: |
      The sequence can be from the first or second read [1/2].
      Required.
    type: int
    inputBinding:
      prefix: BARCODED_READ=
  summary:
    doc: |
      Summary of barcode base quality  Default value: null.
    default: ""
    type: string?
    inputBinding:
      prefix: SUMMARY=
      valueFrom: |
        ${
          if (inputs.summary == "") {
            return inputs.input.nameroot + ".tagged" + inputs.base_range + ".summary";
          }
          else {
            return inputs.summary;
          }
        }
  base_range:
    doc: |
      Base range to extract, seperated by a dash.  IE: 1-4.
    type: string
    inputBinding:
      prefix: BASE_RANGE=
  tag_name:
    doc: |
      Barcode tag.  This is typically X plus one more capitalized alpha.
    type: string
    inputBinding:
      prefix: TAG_NAME=
  discard_read:
    doc: |
      Discard the read the sequence came from?.
      If this is true, then the remaining read is marked as unpaired.
      If the read is unpaired, then you can't discard a read.
      This option can be set to 'null' to clear the default value.
    type: string
    inputBinding:
      prefix: DISCARD_READ=

outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return inputs.input.nameroot + ".tagged" + inputs.base_range + ".bam";
          }
          else {
            return inputs.output;
          }
        }
  output_summary:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.summary == "") {
            return inputs.input.nameroot + ".tagged" + inputs.base_range + ".summary";
          }
          else {
            return inputs.summary;
          }
        }