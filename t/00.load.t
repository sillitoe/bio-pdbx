use Test::More tests => 2;

BEGIN {
use_ok( 'Bio::PDBx::NoAtom' );
use_ok( 'Bio::PDBx::WebService' );
}

diag( "Testing Bio::PDBx $Bio::PDBx::NoAtom::VERSION" );
