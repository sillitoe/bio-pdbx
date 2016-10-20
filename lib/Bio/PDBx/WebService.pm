package Bio::PDBx::WebService;

=head1 NAME

Bio::PDBx::WebService - retrieve PDB header information from remote server

=head1 SYNOPSIS

  $ws = Bio::PDBx::WebService->new();

  $pdb = $ws->get( id => '1cuk' );

  $pdb->id                        # '1CUK'
  $pdb->method                    # 'X-RAY DIFFRACTION'
  $pdb->host_org_genus            # 'Escherichia'
  $pdb->primary_citation_title;   # 'Crystal structure of DNA recombination
                                  #  protein RuvA and a model for its
                                  #  binding to the Holliday junction.'

See L<Bio::PDBx::NoAtom>

=head1 OPTIONS

Customising options...

  $ws = Bio::PDBx::WebService->new();

  # is roughly equivalent to...

  $ws = Bio::PDBx::WebService->new(
    url_template => "http://www.rcsb.org/pdb/files/__ID__.xml?headerOnly=YES",
    cache_dir    => "$ENV{HOME}/.pdb-noatom/",
    timeout      => 10,
    no_cache     => 0,
  );

PDB XML files will be cached and reused where possible (unless told otherwise)

  $pdb = $ws->get( id => '1cuk' );

  # ~/.pdb-noatom/1cuk-noatom.xml

  $xml = $ws->get( id => '1cuk', file => 'custom-file.xml' );

  # ./custom-file.xml

=cut

use Moose;
use Carp qw/ croak /;
use MooseX::Params::Validate;
use MooseX::Types::Path::Class qw/ File Dir /;
use Path::Class;
use LWP::UserAgent;
use File::HomeDir;
use Try::Tiny;
use Moose::Util::TypeConstraints;
use Bio::PDBx::NoAtom;
use namespace::autoclean;

subtype 'PdbId',
  as 'Str',
  where { $_ =~ /^[0-9][a-zA-Z]{3}$/ },
  message { "String '$_' does not look like a valid PDB code" };

coerce 'PdbId',
  from 'Str',
  via { uc($_) }; # dangerous to normalise PDB id to uppercase?

=head1 METHODS

=head2 get( id => '1cuk' )

Retrieves the data from the remote server and returns L<Bio::PDBx::NoAtom>

The C<id> parameter is required and corresponds to the 4 character PDB code.

=head3 options

The following parameters can be used to override default settings

=over

=item file => Str

Output file in which the XML data will be stored

Default: C<$self->cache_dir->file( $ID . '-noatom.xml' )>

=item url => Str

Override the remote location from which the PDB XML data will be retrieved

Default: C<$self->url_template>

=item no_cache => Bool

Do not use previously cached files

Default: 0

=back

=cut

sub get {
  my ($self, %params) = validated_hash( \@_,
    id       => { isa => 'PdbId', coerce => 1 },
    file     => { isa => File, coerce => 1, optional => 1 },
    url      => { isa => 'Str', optional => 1 },
    no_cache => { isa => 'Bool', optional => 1 },
  );

  my $ua       = $self->ua;
  my $id       = $params{id};
  my $file     = $params{file}     || $self->cache_dir->file( $id . '-pdb-noatom.xml' );
  my $url      = $params{url}      || $self->url_template;
  my $no_cache = $params{no_cache} || $self->no_cache;

  if ( -e $file && -s $file > 0 && !$no_cache ) {
    my $xml =
      try {
        Bio::PDBx::NoAtom->new( file => $file )->parse;
      }
      catch {
        warn "WARNING: caught unexpected error when using cached PDB XML file '$file': $_ (will re-GET data and try again)";
        return;
      };
    return $xml if $xml;
  }

  # swap in the PDB id wherever it might appear
  $url =~ s/__ID__/$id/mg;

  my $response = $ua->get( $url );

  if ( $response->is_success ) {
    my $fh = $file->openw
      or croak "! Error: failed to open PDB XML file '$file' for writing: $!";
    $fh->print( $response->decoded_content );
  }
  else {
    croak "! Error: encountered a problem getting the remote PDB XML file:\n"
      . "  URL:    " . $url . "\n"
      . "  STATUS: " . $response->status_line . "\n"
      ;
  }

  my $xml = Bio::PDBx::NoAtom->new( file => $file )->parse;

  return $xml;
}


=head1 ATTRIBUTES

The following options can be added to the constructor to modify the default
behaviour.

=head2 url_template => Str

URL to use for the remote GET.

Note: the string '__ID__' will be replaced with the given PDB ID

Default:

  http://files.rcsb.org/view/__ID__-noatom.xml

=cut

has url_template => (
  is => 'ro',
  isa => 'Str',
  default => 'http://files.rcsb.org/view/__ID__-noatom.xml',
);

=head2 no_cache => Bool

Decide whether to allow files to be cached. If the output file already exists
and this setting is set to false then the remote server will not be contacted.
If this is turned on then the server is always contacted and any existing
files will be overwritten.

Default: false

=cut

has no_cache => (
  is => 'ro',
  isa => 'Bool',
  default => 0,
);

=head2 cache_dir => Dir

Specify a custom directory in which to store the resulting PDB files.

Default:

  $HOME/.pdb-noatom/

=cut

has cache_dir => (
  is => 'ro',
  isa => Dir,
  lazy => 1,
  builder => '_build_cache_dir',
);

sub _build_cache_dir {
  my $self = shift;
  my $cache_dir = dir( File::HomeDir->my_home, '.pdb-noatom' );
  if ( !-d $cache_dir ) {
    $cache_dir->mkpath;
  }
  return $cache_dir;
}

=head2 timeout => Int

Time in seconds to allow for the web transaction before quitting

Default: C<10>

=cut

has timeout => (
  is => 'ro',
  isa => 'Int',
  default => 10,
);

=head2 ua => LWP::UserAgent

Override the default agent used for the web transaction

=cut

has ua => (
  is => 'ro',
  isa => 'LWP::UserAgent',
  lazy => 1,
  builder => '_build_ua',
);

sub _build_ua {
  my $self = shift;
  my $ua = LWP::UserAgent->new;
  $ua->timeout( $self->timeout );
  return $ua;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
