use strict;
use warnings;
use inc::Module::Install;
use 5.008;

name 'Bio-PDB-NoAtom';
perl_version '5.008';
all_from 'lib/Bio/PDBx/NoAtom.pm';
license 'perl';

requires 'namespace::autoclean'         => '0.09';
requires 'Module::Install';
requires 'XML::Rabbit'                  => '0.3.0';
requires 'Moose';
requires 'MooseX::Types::Path::Class';
requires 'Try::Tiny';
requires 'XML::Rabbit::Root';

# things the tests need
build_requires 'Test::More'      => '0.77';

tests_recursive();

#auto_install();

#auto_manifest();

WriteAll();

if ($Module::Install::AUTHOR) {
  system('pod2text lib/Bio/PDBx/NoAtom.pm > README');
}
