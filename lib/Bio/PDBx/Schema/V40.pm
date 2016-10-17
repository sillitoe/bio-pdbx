package Bio::PDBx::Schema::V40;

use XML::Rabbit;

add_xpath_namespace 'PDBx' => 'http://pdbml.pdb.org/schema/pdbx-v40.xsd';

extends 'Bio::PDBx::SchemaBase';

finalize_class();
