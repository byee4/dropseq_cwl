#!/usr/bin/env cwltool

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  assay_protocol:
    type: string
  contact_email:
    type: string
  experiment_nickname:
    type: string
  experiment_start_date:
    type: string
  experiment_summary:
    type: string
  extract_protocol_description:
    type: string
  growth_protocol_description:
    type: string
  investigator:
    type: string
  library_construction_protocol:
    type: string
  library_strategy:
    type: string
  organism:
    type: string
  pi_name:
    type: string
  sequencing_center:
    type: string
  processing_date:
    type: string

  samples:
    type:
      type: array
      items:
        type: record
        fields:
          expt_id:
            type: string
          sample_id:
            type: string
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
  sequencing_center:
    type: string
  sequencing_date:
    type: string
  treatment_protocol_description:
    type: string

outputs:


  ### PREPROCESSING OUTPUTS ###

  # REMOVING DUE TO SIZE CONSTRAINTS

  # output_fastq_to_sam:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_fastq_to_sam


  ### BARCODE/UMI ASSIGNMENTS ###

  # REMOVING DUE TO SIZE CONSTRAINTS

  # output_tag_cell_barcodes:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_tag_cell_barcodes
  output_tag_cell_barcodes_summary:
    type: File[]
    outputSource: step_dropseq_count/output_tag_cell_barcodes_summary
  # output_tag_molecular_barcodes:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_tag_molecular_barcodes
  output_tag_molecular_barcodes_summary:
    type: File[]
    outputSource: step_dropseq_count/output_tag_molecular_barcodes_summary


  ### TRIMMING ###

  # REMOVING DUE TO SIZE CONSTRAINTS

  # output_trim_5p_primer_sequence:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_trim_5p_primer_sequence
  output_trim_5p_primer_sequence_summary:
    type: File[]
    outputSource: step_dropseq_count/output_trim_5p_primer_sequence_summary
  # output_trim_3p_polya_sequence:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_trim_3p_polya_sequence
  output_trim_3p_polya_sequence_summary:
    type: File[]
    outputSource: step_dropseq_count/output_trim_3p_polya_sequence_summary


  ### GENOME ALIGNMENTS ###

  output_star_alignment:
    type: File[]
    outputSource: step_dropseq_count/output_star_alignment
  output_star_alignment_map_unmapped_fwd:
    type: File[]
    outputSource: step_dropseq_count/output_star_alignment_map_unmapped_fwd
  output_star_alignment_starsettings:
    type: File[]
    outputSource: step_dropseq_count/output_star_alignment_starsettings
  output_star_alignment_mappingstats:
    type: File[]
    outputSource: step_dropseq_count/output_star_alignment_mappingstats


  ### POST PROCESSING ALIGNMENT OUTPUTS ###

  # REMOVING DUE TO SIZE CONSTRAINTS

  # output_sort_alignment_queryname:
  #   type: File[]
  #   outputSource: step_dropseq_count/output_sort_alignment_queryname
  output_merge_alignment:
    type: File[]
    outputSource: step_dropseq_count/output_merge_alignment
  output_add_gene_exon_tags:
    type: File[]
    outputSource: step_dropseq_count/output_add_gene_exon_tags


  ### QC ###


  output_detect_bead_synthesis_errors:
    type: File[]
    outputSource: step_dropseq_count/output_detect_bead_synthesis_errors
  output_detect_bead_synthesis_errors_summary:
    type: File[]
    outputSource: step_dropseq_count/output_detect_bead_synthesis_errors_summary
  output_detect_bead_synthesis_errors_stats:
    type: File[]
    outputSource: step_dropseq_count/output_detect_bead_synthesis_errors_stats


  ### EXPRESSION ###


  output_digital_expression:
    type: File[]
    outputSource: step_dropseq_count/output_digital_expression
  output_digital_expression_summary:
    type: File[]
    outputSource: step_dropseq_count/output_digital_expression_summary

steps:

###########################################################################
# Upstream (preprocessing)
###########################################################################

  step_dropseq_count:
    run: wf_dropseq_count.cwl
    scatter: sample
    in:
      assay_protocol: assay_protocol
      contact_email: contact_email
      experiment_nickname: experiment_nickname
      experiment_start_date: experiment_start_date
      experiment_summary: experiment_summary
      extract_protocol_description: extract_protocol_description
      growth_protocol_description: growth_protocol_description
      investigator: investigator
      library_construction_protocol: library_construction_protocol
      library_strategy: library_strategy
      organism: organism
      pi_name: pi_name
      processing_date: processing_date
      sample: samples
      sequencing_center: sequencing_center
      sequencing_date: sequencing_date
      treatment_protocol_description: treatment_protocol_description
    out:
      - output_fastq_to_sam
      - output_tag_cell_barcodes
      - output_tag_cell_barcodes_summary
      - output_tag_molecular_barcodes
      - output_tag_molecular_barcodes_summary
      - output_trim_5p_primer_sequence
      - output_trim_5p_primer_sequence_summary
      - output_trim_3p_polya_sequence
      - output_trim_3p_polya_sequence_summary
      - output_star_alignment
      - output_star_alignment_map_unmapped_fwd
      - output_star_alignment_starsettings
      - output_star_alignment_mappingstats
      - output_sort_alignment_queryname
      - output_merge_alignment
      - output_add_gene_exon_tags
      - output_detect_bead_synthesis_errors
      - output_detect_bead_synthesis_errors_summary
      - output_detect_bead_synthesis_errors_stats
      - output_digital_expression
      - output_digital_expression_summary
