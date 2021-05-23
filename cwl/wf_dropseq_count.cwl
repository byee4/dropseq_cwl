#!/usr/bin/env cwltool

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

  module:
    type: string
  module_version:
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
  processing_date:
    type: string
  sample:
    type:
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


  output_fastq_to_sam:
    type: File
    outputSource: step_fastq_to_sam/output_file


  ### BARCODE/UMI ASSIGNMENTS ###


  output_tag_cell_barcodes:
    type: File
    outputSource: step_tag_cell_barcodes/output_file
  output_tag_cell_barcodes_summary:
    type: File
    outputSource: step_tag_cell_barcodes/output_summary
  output_tag_molecular_barcodes:
    type: File
    outputSource: step_tag_molecular_barcodes/output_file
  output_tag_molecular_barcodes_summary:
    type: File
    outputSource: step_tag_molecular_barcodes/output_summary


  ### TRIMMING ###


  output_trim_5p_primer_sequence:
    type: File
    outputSource: step_trim_5p_primer_sequence/output_file
  output_trim_5p_primer_sequence_summary:
    type: File
    outputSource: step_trim_5p_primer_sequence/output_summary_file
  output_trim_3p_polya_sequence:
    type: File
    outputSource: step_trim_3p_polya_sequence/output_file
  output_trim_3p_polya_sequence_summary:
    type: File
    outputSource: step_trim_3p_polya_sequence/output_summary_file


  ### GENOME ALIGNMENTS ###


  output_star_alignment:
    type: File
    outputSource: step_star_alignment/aligned
  output_star_alignment_map_unmapped_fwd:
    type: File
    outputSource: step_star_alignment/output_map_unmapped_fwd
  output_star_alignment_starsettings:
    type: File
    outputSource: step_star_alignment/starsettings
  output_star_alignment_mappingstats:
    type: File
    outputSource: step_star_alignment/mappingstats


  ### POST PROCESSING ALIGNMENT OUTPUTS ###


  output_sort_alignment_queryname:
    type: File
    outputSource: step_sort_alignment_queryname/output_file
  output_merge_alignment:
    type: File
    outputSource: step_merge_alignment/output_file
  output_add_gene_exon_tags:
    type: File
    outputSource: step_add_gene_exon_tags/output_file


  ### QC ###


  output_detect_bead_synthesis_errors:
    type: File
    outputSource: step_detect_bead_synthesis_errors/output_file
  output_detect_bead_synthesis_errors_summary:
    type: File
    outputSource: step_detect_bead_synthesis_errors/output_summary_file
  output_detect_bead_synthesis_errors_stats:
    type: File
    outputSource: step_detect_bead_synthesis_errors/output_stats_file


  ### EXPRESSION ###


  output_digital_expression:
    type: File
    outputSource: step_digital_expression/output_file
  output_digital_expression_summary:
    type: File
    outputSource: step_digital_expression/output_summary_file

steps:

###########################################################################
# Upstream (preprocessing)
###########################################################################

  step_parse_sample:
    run: parse_sample.cwl
    in:
      sample: sample
    out:
      - sample_name
      - initial_sam_file_name
      - read1
      - read2
      - core_barcodes
      - expected_barcodes
      - species_genome_dir
      - species_reference_fasta
      - species_reference_refFlat

  step_fastq_to_sam:
    run: FastqToSam.cwl
    in:
      fastq: step_parse_sample/read1
      fastq2: step_parse_sample/read2
      output: step_parse_sample/initial_sam_file_name
      sample_name: step_parse_sample/sample_name
    out:
      - output_file

###########################################################################
# Count
###########################################################################

  step_tag_cell_barcodes:
    run: TagBamWithReadSequenceExtended.cwl
    in:
      input: step_fastq_to_sam/output_file
      base_range:
        default: "1-12"
      barcoded_read:
        default: 1
      tag_name:
        default: "XC"
      discard_read:
        default: "false"
    out:
      - output_file
      - output_summary

  step_tag_molecular_barcodes:
    run: TagBamWithReadSequenceExtended.cwl
    in:
      input: step_tag_cell_barcodes/output_file
      base_range:
        default: "13-20"
      barcoded_read:
        default: 1
      tag_name:
        default: "XM"
      discard_read:
        default: "true"
    out:
      - output_file
      - output_summary

  step_filter_bam:
    run: FilterBAM.cwl
    in:
      input: step_tag_molecular_barcodes/output_file
      tag_reject:
        default: "XQ"
    out:
      - output_file

  step_trim_5p_primer_sequence:
    run: TrimStartingSequence.cwl
    in:
      input: step_filter_bam/output_file
      sequence:
        default: AAGCAGTGGTATCAACGCAGAGTGAATGGG
      num_bases:
        default: 5
      mismatches:
        default: 0
    out:
      - output_file
      - output_summary_file

  step_trim_3p_polya_sequence:
    run: PolyATrimmer.cwl
    in:
      input: step_trim_5p_primer_sequence/output_file
    out:
      - output_file
      - output_summary_file

  step_sam_to_fastq:
    run: SamToFastq.cwl
    in:
      input: step_trim_3p_polya_sequence/output_file
    out:
      - output_fastq_file

  step_star_alignment:
    run: star.cwl
    in:
      genomeDir: step_parse_sample/species_genome_dir
      readFilesIn:
        source: step_sam_to_fastq/output_fastq_file
        valueFrom: ${ return [ self ]; }
    out:
      - aligned
      - output_map_unmapped_fwd
      - starsettings
      - mappingstats

  step_sort_alignment_queryname:
    run: SortSam.cwl
    in:
      input: step_star_alignment/aligned
      sort_order:
        default: "queryname"
    out:
      - output_file

  step_create_sequence_dict:
    run: CreateSequenceDictionary.cwl
    in:
      reference: step_parse_sample/species_reference_fasta
    out:
      - reference_with_index

  step_merge_alignment:
    run: MergeBamAlignment.cwl
    in:
      reference_sequence: step_create_sequence_dict/reference_with_index
      aligned_bam: step_sort_alignment_queryname/output_file
      unmapped_bam: step_trim_3p_polya_sequence/output_file
    out:
      - output_file

  step_add_gene_exon_tags:
    run: TagReadWithGeneExon.cwl
    in:
      input: step_merge_alignment/output_file
      annotation_file: step_parse_sample/species_reference_refFlat
    out:
      - output_file
  step_detect_bead_synthesis_errors:
    run: DetectBeadSynthesisErrors.cwl
    in:
      input: step_add_gene_exon_tags/output_file
      num_barcodes: step_parse_sample/expected_barcodes
      primer_sequence:
        default: "AAGCAGTGGTATCAACGCAGAGTAC"
    out:
      - output_file
      - output_summary_file
      - output_stats_file

###########################################################################
# Downstream (expression)
###########################################################################

  step_digital_expression:
    run: DigitalExpression.cwl
    in:
      input: step_detect_bead_synthesis_errors/output_file
      num_core_barcodes: step_parse_sample/core_barcodes
    out:
      - output_file
      - output_summary_file
