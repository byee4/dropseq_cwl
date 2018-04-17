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

baseCommand: [TagReadWithGeneExon]


inputs:
  input:
    doc: |
      The input SAM or BAM file to analyze  Required.
    type: File
    inputBinding:
      prefix: INPUT=
  annotation_file:
    doc: |
       The annotations set to use to label the read.
       This can be a GTF or a refFlat file.
    type: File
    inputBinding:
      prefix: ANNOTATIONS_FILE=
  tag:
    doc: |
      The tag name to use.  When there are multiple genes,
      they will be comma seperated.
    default: "GE"
    type: string
    inputBinding:
      prefix: TAG=
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
            return inputs.input.nameroot + ".TaggedGeneExon.bam";
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
            return inputs.input.nameroot + ".TaggedGeneExon.bam";
          }
          else {
            return inputs.output;
          }
        }