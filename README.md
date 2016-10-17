# Bio-PDBx-NoAtom

Simple access to data in PDB XML header files

```
use Bio::PDBx::NoAtom;

my $xml_file = '1cuk-noatom.xml'; # or '1cuk-noatom.xml.gz'

my $pdb = Bio::PDBx::NoAtom->new( file => $xml_file )->parse;

$pdb->id                        # '1CUK'

$pdb->method                    # 'X-RAY DIFFRACTION'

$pdb->host_org_genus            # 'Escherichia'

$pdb->primary_citation_title;   # 'Crystal structure of DNA recombination
                                #  protein RuvA and a model for its
                                #  binding to the Holliday junction.'
```

## DESCRIPTION

Currently this requires you to have a local copy of the PDB XML header
files.

The entire dataset is available for download:

    ftp://ftp.wwpdb.org/pub/data/structures/all/XML-noatom

These files can be accessed individually via:

    http://www.rcsb.org/pdb/files/4hhb.xml?headerOnly=YES

## METHODS

The following functions are all read only accessors returning a string.

```
$pdb->id
$pdb->pubmed_id
$pdb->primary_citation_country
$pdb->primary_citation_journal_abbrev
$pdb->primary_citation_journal_volume
$pdb->primary_citation_page_first
$pdb->primary_citation_page_last
$pdb->primary_citation_title
$pdb->primary_citation_year
$pdb->gene_src_common_name
$pdb->gene_src_details
$pdb->gene_src_genus
$pdb->gene_src_species
$pdb->gene_src_strain
$pdb->gene_src_tissue
$pdb->gene_src_tissue_fraction
$pdb->host_org_common_name
$pdb->host_org_genus
$pdb->host_org_species
$pdb->pdbx_description
$pdb->pdbx_gene_src_atcc
$pdb->pdbx_gene_src_cell
$pdb->pdbx_gene_src_cell_line
$pdb->pdbx_gene_src_cellular_location
$pdb->pdbx_gene_src_fragment
$pdb->pdbx_gene_src_gene
$pdb->pdbx_gene_src_ncbi_taxonomy_id
$pdb->pdbx_gene_src_organ
$pdb->pdbx_gene_src_organelle
$pdb->pdbx_gene_src_scientific_name
$pdb->pdbx_gene_src_variant
$pdb->pdbx_host_org_atcc
$pdb->pdbx_host_org_cell
$pdb->pdbx_host_org_cell_line
$pdb->pdbx_host_org_cellular_location
$pdb->pdbx_host_org_culture_collection
$pdb->pdbx_host_org_gene
$pdb->pdbx_host_org_ncbi_taxonomy_id
$pdb->pdbx_host_org_organ
$pdb->pdbx_host_org_organelle
$pdb->pdbx_host_org_scientific_name
$pdb->pdbx_host_org_strain
$pdb->pdbx_host_org_tissue
$pdb->pdbx_host_org_tissue_fraction
$pdb->pdbx_host_org_variant
$pdb->pdbx_host_org_vector
$pdb->pdbx_host_org_vector_type
$pdb->plasmid_details
$pdb->plasmid_name
```

## DEPENDENCIES

```
XML::Rabbit
```

## BUGS AND LIMITATIONS

This does not currently encode all the information in the PDBx files,
mainly just the fields that I thought would be useful. Suggestions for
further access welcome.

## LICENCE AND COPYRIGHT

Copyright (c) 2016, Ian Sillitoe "<isillitoe@cpan.org>". All rights
reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See perlartistic.
