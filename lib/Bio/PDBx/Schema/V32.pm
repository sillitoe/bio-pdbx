package Bio::PDBx::Schema::V32;

use XML::Rabbit;

add_xpath_namespace 'PDBx' => 'http://pdbml.pdb.org/schema/pdbx-v32.xsd';

extends 'Bio::PDBx::SchemaBase';

finalize_class();
