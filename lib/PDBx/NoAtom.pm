package PDBx::NoAtom;

use Moose;
use Carp qw/ croak /;
use MooseX::Types::Path::Class qw/ File /;
use PDBx::Schema::V32;
use PDBx::Schema::V40;
use PDBx::Schema::V42;
use Try::Tiny;
use IO::Uncompress::Gunzip qw/ $GunzipError /;
use namespace::autoclean;

our $VERSION = "0.02";

has file => (
  is => 'ro',
  isa => File,
  coerce => 1,
  required => 1,
);

has pdbx_schema_version => (
  is  => 'ro',
  isa => 'Str',
  lazy => 1,
  builder => '_build_pdbx_schema_version',
);

sub _build_pdbx_schema_version {
  my $self = shift;
  my $xml_file = $self->file;
  my $xml_fh = IO::Uncompress::Gunzip->new( "$xml_file" ) or croak "Error: problem opening PDBx XML file `$xml_file`: $GunzipError";
  while ( $_ = $xml_fh->getline ) {
    if ( /xmlns:PDBx\s*=\s*".*pdbx-v(\d+)\.xsd"/ ) {
      return $1;
    }
  }
  croak "Error: failed to find expected PDBx namespace in xml file `$xml_file`";
}


sub parse {
  my $self = shift;
  my $schema_class = "PDBx::Schema::V" . $self->pdbx_schema_version;
  my $xml_file = $self->file;
  my $schema = try { $schema_class->new( file => "$xml_file" ) }
  catch { 
    croak "Error: failed to create new `$schema_class` object: $_";
  };
  return $schema;
}

1;
__END__

=head1 NAME

PDBx::NoAtom - simple access to PDBx data (Protein Data Bank XML)

=head1 SYNOPSIS

    use PDBx::NoAtom;
    
    my $xml_file = '1cuk-noatom.xml'; # or '1cuk-noatom.xml.gz'
        
    my $pdb = PDBx::NoAtom->new( file => $xml_file )->parse;

    $pdb->id                        # '1CUK'

    $pdb->method                    # 'X-RAY DIFFRACTION'

    $pdb->host_org_genus            # 'Escherichia'

    $pdb->primary_citation_title;   # 'Crystal structure of DNA recombination
                                    #  protein RuvA and a model for its
                                    #  binding to the Holliday junction.'


=head1 DESCRIPTION

Currently this requires you to have a local copy of the PDB XML header files.
    
    ftp://ftp.wwpdb.org/pub/data/structures/all/XML-noatom

You can also access these files individually over HTTP via:

    http://www.rcsb.org/pdb/files/4hhb.xml?headerOnly=YES

=head1 FUNCTIONS

The following functions are all read only accessors returning a string.

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


=head1 DEPENDENCIES

XML::Rabbit

=head1 BUGS AND LIMITATIONS

This does not currently encode all the information in the PDBx files, mainly just the fields that I thought
would be useful. Suggestions for further access welcome.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-pdbx@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Ian Sillitoe  C<< <isillitoe@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Ian Sillitoe C<< <isillitoe@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
