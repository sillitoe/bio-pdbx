package Bio::PDBx::Schema::V42;

use XML::Rabbit;

add_xpath_namespace 'PDBx' => 'http://pdbml.pdb.org/schema/pdbx-v42.xsd';

extends 'Bio::PDBx::SchemaBase';

finalize_class();
