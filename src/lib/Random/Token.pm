package Random::Token;

use Moo;
use MVU::Env qw(is_production);

has dir => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

has name => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

has file => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

has randomized => (
    is      => 'rw',
    default => sub { 1 },
);

sub _build_dir {
    my $dir = "/tmp/tokens";
    mkdir $dir if !-d $dir;
    return $dir;
}

sub _build_name { 'web' }

sub _build_file {
    my ($self) = @_;
    return sprintf '%s/%s', $self->dir, $self->name;
}

sub content {
    my ($self) = @_;
    open my $fh, '<', $self->file or return;
    local $/;
    <$fh>;
}

sub random_number {
    my $token = rand();
    $token =~ s /^0\.//;
    return $token;
}

sub fetch {
    my ($self) = @_;
    my $file = $self->file;
    return if !-f $file && MVU::Env->is_production;
    return $self->content // ( $self->randomized ? random_number : '' );
}

sub set {
    my ( $self, $token ) = @_;
    $token //= $self->randomized ? random_number : die 'Plase provide a token';
    open my $fh, '>', $self->file or die "Unable to set token. $!";
    print $fh $token;
    return $token;
}

sub del {
    my ($self) = @_;
    unlink $self->file;
}

1;
