use Test::More tests => 8;

use FindBin;
use Data::Dumper;
use File::Temp qw/ tempfile /;

diag( "NOTE: these tests check the webservice and will require access to external network");

use_ok( 'Bio::PDBx::WebService' );

{
  my $ws = Bio::PDBx::WebService->new();

  isa_ok( $ws, 'Bio::PDBx::WebService', 'new' );

  my $pdb = $ws->get( id => '1cuk' );

  is( $pdb->id, '1CUK', 'pdb id' );
  is( $pdb->method, 'X-RAY DIFFRACTION', 'method' );
  is( $pdb->host_org_genus, 'Escherichia', 'host_org_genus' );
  is( $pdb->primary_citation_title, 'Crystal structure of DNA recombination protein RuvA and a model for its binding to the Holliday junction.',
      'primary_citation_title'
  );
}

{
  my $ws = Bio::PDBx::WebService->new();

  isa_ok( $ws, 'Bio::PDBx::WebService', 'new' );

  my ($tmp_fh, $tmp_file) = tempfile();

  my $pdb = $ws->get( id => '1cuk', file => $tmp_file );

  ok( -e $tmp_file, 'custom file exists' );
}
