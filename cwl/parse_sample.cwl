#!/usr/bin/env cwltool

### parses a record object ###

cwlVersion: v1.0
class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:

  sample:
    type:
      type: record
      fields:
        expt_id:
           type: string
        sample_id:
          type: string?
        read1:
          type: File
        read1_length:
          type: int
        read2:
          type: File
        read2_length:
          type: int
        library_prep:
          type: string
        core_barcodes:
          type: int
        expected_barcodes:
          type: int
        instrument_model:
          type: string
        species_genome_dir:
          type: Directory
        species_reference_fasta:
          type: File
        species_reference_refFlat:
          type: File
        characteristics:
          type:
            type: array
            items:
              type: record
              name: characteristics
              fields:
                name:
                  type: string
                value:
                  type: string

outputs:
  sample_name:
    type: string
  initial_sam_file_name:
    type: string
  read1:
    type: File
  read2:
    type: File
  core_barcodes:
    type: int
  expected_barcodes:
    type: int
  species_genome_dir:
    type: Directory
  species_reference_fasta:
    type: File
  species_reference_refFlat:
    type: File

expression: |
   ${
      return {
        'sample_name': inputs.sample.expt_id + "_" + inputs.sample.sample_id,
        'initial_sam_file_name': inputs.sample.expt_id + "_" + inputs.sample.sample_id + ".sam",
        'read1':inputs.sample.read1,
        'read2':inputs.sample.read2,
        'core_barcodes':inputs.sample.core_barcodes,
        'expected_barcodes':inputs.sample.expected_barcodes,
        'species_genome_dir':inputs.sample.species_genome_dir,
        'species_reference_fasta':inputs.sample.species_reference_fasta,
        'species_reference_refFlat':inputs.sample.species_reference_refFlat,
      };
    }

doc: |
  This tool parses an array of records, with each record containing
    Usage: