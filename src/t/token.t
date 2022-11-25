use strict;
use warnings;
use Test::More;
use lib 'src/lib';
use Random::Token;

my $t = Random::Token->new(randomized => 0);

$t->del;

is $t->file, '/tmp/tokens/web';
is $t->fetch, '';

my $expected = $t->random_number;
$t->set($expected);

my $got = $t->fetch;
is $got, $expected;

done_testing;
