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
  - class: InitialWorkDirRequirement
    listing: [ $(inputs.reference) ]

baseCommand: [picard, CreateSequenceDictionary]

arguments:
  - valueFrom: -Xmx4g
    position: -1

inputs:
  reference:
    doc: |
      Reference sequence file.  Required.
    type: File
    inputBinding:
      prefix: REFERENCE=
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
            return inputs.reference.basename + ".dict";
          }
          else {
            return inputs.output;
          }
        }


outputs:
  reference_with_index:
    type: File
    secondaryFiles: .dict
    outputBinding:
      glob: $(inputs.reference.basename)
    doc: The index file