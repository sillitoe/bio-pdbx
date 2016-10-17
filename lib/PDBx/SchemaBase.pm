package PDBx::SchemaBase;

use XML::Rabbit::Root;

has_xpath_value 'id' => '//PDBx:entryCategory/PDBx:entry[1]/@id',
  isa      => 'Str',
  required => 1,
;

has_xpath_value 'method' => '//PDBx:exptlCategory/PDBx:exptl[1]/@method',
  isa      => 'Str',
  required => 1,
;

map {
  has_xpath_value 'primary_citation_' . $_ => q{//PDBx:citationCategory/PDBx:citation[@id='primary']/PDBx:} . $_,  
  isa => 'Str',
;

} qw(
    country
    journal_abbrev
    journal_volume
    page_first
    page_last
    pdbx_database_id_PubMed
    title
    year
);

sub pubmed_id {
    my $self = shift;
    $self->primary_citation_pdbx_database_id_PubMed;
}

has_xpath_value_list 'primary_citation_authors' => q{//PDBx:citation_authorCategory/PDBx:citation_author[@citation_id='primary']/@name},
  isa => 'ArrayRef',
;

map { 
  has_xpath_value $_ => '//PDBx:' . $_, isa  => 'Str';
} qw/
    gene_src_common_name
    gene_src_details
    gene_src_genus
    gene_src_species
    gene_src_strain
    gene_src_tissue
    gene_src_tissue_fraction
    host_org_common_name
    host_org_genus
    host_org_species
    pdbx_gene_src_atcc
    pdbx_gene_src_cell
    pdbx_gene_src_cell_line
    pdbx_gene_src_cellular_location
    pdbx_gene_src_fragment
    pdbx_gene_src_gene
    pdbx_gene_src_ncbi_taxonomy_id
    pdbx_gene_src_organ
    pdbx_gene_src_organelle
    pdbx_gene_src_scientific_name
    pdbx_gene_src_variant
    pdbx_host_org_atcc
    pdbx_host_org_cell
    pdbx_host_org_cell_line
    pdbx_host_org_cellular_location
    pdbx_host_org_culture_collection
    pdbx_host_org_gene
    pdbx_host_org_ncbi_taxonomy_id
    pdbx_host_org_organ
    pdbx_host_org_organelle
    pdbx_host_org_scientific_name
    pdbx_host_org_strain
    pdbx_host_org_tissue
    pdbx_host_org_tissue_fraction
    pdbx_host_org_variant
    pdbx_host_org_vector
    pdbx_host_org_vector_type
    plasmid_details
    plasmid_name
/;



