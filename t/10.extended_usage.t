use Test::More;

use strict;
use warnings;

use PDBx::NoAtom;
use FindBin;

my $pdb = PDBx::NoAtom->new( file => "$FindBin::Bin/1cuk-noatom.xml" )->parse;

isa_ok( my $authors_ref = $pdb->primary_citation_authors, 'ARRAY', 'authors' );

is_deeply( $authors_ref, 
	[
		'Rafferty, J.B.',
        'Sedelnikova, S.E.',
        'Hargreaves, D.',
        'Artymiuk, P.J.',
        'Baker, P.J.',
        'Sharples, G.J.',
        'Mahdi, A.A.',
        'Lloyd, R.G.',
        'Rice, D.W.'
	], 'primary citation authors look okay' );

done_testing();