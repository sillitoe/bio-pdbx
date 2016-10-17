use Test::More tests => 22;

use FindBin;
use Data::Dumper;

use_ok( 'PDBx::NoAtom' );

{
  my $pdb_xml_file            = $FindBin::Bin . "/1cuk-noatom.xml";
  my $pdb_xml_gzipped_file    = $pdb_xml_file . ".gz";

  # TODO:
  # my $pdb_xml_remote = 'http://www.rcsb.org/pdb/files/4hhb.xml?headerOnly=YES';

  isa_ok( my $pdb = PDBx::NoAtom->new( file => $pdb_xml_file )->parse, 'PDBx::Schema::V40', 'new from file' );

  is( $pdb->id, '1CUK', 'pdb id' );

  is( $pdb->method, 'X-RAY DIFFRACTION', 'method' );

  is( $pdb->host_org_genus, 'Escherichia', 'host_org_genus' );

  is( $pdb->primary_citation_title, 'Crystal structure of DNA recombination protein RuvA and a model for its binding to the Holliday junction.',
      'primary_citation_title'
  );

  isa_ok( my $pdb_gz = PDBx::NoAtom->new( file => $pdb_xml_gzipped_file )->parse, 'PDBx::Schema::V40', 'new (from gzip)' );

  is( $pdb_gz->id, '1CUK', 'pdb id (from gzip)' );
}

{
  my $pdb_xml_file            = $FindBin::Bin . "/5d4j-noatom.xml";
  my $pdb_xml_gzipped_file    = $pdb_xml_file . ".gz";

  # TODO:
  # my $pdb_xml_remote = 'http://www.rcsb.org/pdb/files/4hhb.xml?headerOnly=YES';

  isa_ok( my $pdb = PDBx::NoAtom->new( file => $pdb_xml_file )->parse, 'PDBx::Schema::V42', 'new from file' );

  is( $pdb->id, '5D4J', 'pdb id' );

  is( $pdb->method, 'X-RAY DIFFRACTION', 'method' );

  is( $pdb->host_org_genus, '', 'host_org_genus' );

  is( $pdb->primary_citation_title, 'Redox-coupled proton transfer mechanism in nitrite reductase revealed by femtosecond crystallography',
      'primary_citation_title'
  );

  isa_ok( my $pdb_gz = PDBx::NoAtom->new( file => $pdb_xml_gzipped_file )->parse, 'PDBx::Schema::V42', 'new (from gzip)' );

  is( $pdb_gz->id, '5D4J', 'pdb id (from gzip)' );  
}

{
  my $pdb_xml_file            = $FindBin::Bin . "/2x37-noatom.xml";
  my $pdb_xml_gzipped_file    = $pdb_xml_file . ".gz";

  # TODO:
  # my $pdb_xml_remote = 'http://www.rcsb.org/pdb/files/4hhb.xml?headerOnly=YES';

  isa_ok( my $pdb = PDBx::NoAtom->new( file => $pdb_xml_file )->parse, 'PDBx::Schema::V32', 'new from file' );

  is( $pdb->id, '2X37', 'pdb id' );

  is( $pdb->method, 'X-RAY DIFFRACTION', 'method' );

  is( $pdb->host_org_genus, '', 'host_org_genus' );

  is( $pdb->primary_citation_title, 'Discovery of 4-Amino-1-(7H-Pyrrolo[2,3-D]Pyrimidin-4-Yl)Piperidine-4-Carboxamides as Selective, Orally Active Inhibitors of Protein Kinase B (Akt).',
      'primary_citation_title'
  );

  isa_ok( my $pdb_gz = PDBx::NoAtom->new( file => $pdb_xml_gzipped_file )->parse, 'PDBx::Schema::V32', 'new (from gzip)' );

  is( $pdb_gz->id, '2X37', 'pdb id (from gzip)' );
}
