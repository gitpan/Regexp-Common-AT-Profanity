#!/usr/bin/env perl

use warnings;
use strict;
use Regexp::Common 'AT::Profanity';
use HTML::Entities;
use Test::More;

# rot13 in vim: g?{motion}

my @like = (
    'Qh Uherafbua, Qh!',
    'Nefpuybpu',
    'Vue Bcsref, vpu znfpu rhfpu sregvfpu',
);

my @unlike = (
    'Jawoll, mein Herr',
    'Es ist so sch&ouml;n',
    'Ihr Florist',
    'Iiiinsel!',
);

plan tests => @like + @unlike;

for my $like (@like) {
    my $got = $like;
    $got =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    decode_entities($got);
    like($got, qr/$RE{at}{profanity}/i, "match: $like");
}

for my $unlike (@unlike) {
    my $got = $unlike;
    decode_entities($got);
    unlike($got, qr/$RE{at}{profanity}/i, "no match: $unlike");
}

