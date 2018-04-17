#!/usr/bin/env cwltool

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  investigator:
    type: string
  run_date:
    type: string
  assay_protocol:
    type: string

  samples:
    type:
      type: array
      items:
        type: record
        fields:
          run_id:
            type: string
          sample_id:
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

outputs:


  ### PREPROCESSING OUTPUTS ###


  output_fastq_to_sam:
    type: File[]
    outputSource: step_dropseq_count/output_fastq_to_sam


  ### BARCODE/UMI ASSIGNMENTS ###


  output_tag_cell_barcodes:
    type: File[]
    outputSource: step_dropseq_count/output_tag_cell_barcodes
  output_tag_cell_barcodes_summary:
    type: File[]
    outputSource: step_dropseq_count/output_tag_cell_barcodes_summary
  output_tag_molecular_barcodes:
    type: File[]
    outputSource: step_dropseq_count/output_tag_molecular_barcodes
  output_tag_molecular_barcodes_summary:
    type: File[]
    outputSource: step_dropseq_count/output_tag_molecular_barcodes_summary


  ### TRIMMING ###


  output_trim_5p_primer_sequence:
    type: File[]
    outputSource: step_dropseq_count/output_trim_5p_primer_sequence
  output_trim_5p_primer_sequence_summary:
    type: File[]
    outputSource: step_dropseq_count/output_trim_5p_primer_sequence_summary
  output_trim_3p_polya_sequence:
    type: File[]
    outputSource: step_dropseq_count/output_trim_3p_polya_sequence
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


  output_sort_alignment_queryname:
    type: File[]
    outputSource: step_dropseq_count/output_sort_alignment_queryname
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
      investigator: investigator
      run_date: run_date
      assay_protocol: assay_protocol
      sample: samples
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
