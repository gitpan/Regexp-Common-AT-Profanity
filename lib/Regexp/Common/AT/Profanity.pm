package Regexp::Common::AT::Profanity;

use strict;
use warnings;
use Regexp::Common qw /pattern clean no_defaults/;
use Regexp::Assemble;
use HTML::Entities;


our $VERSION = '0.02';


# rot13 in vim: g?{motion}

my @nouns = qw(
    (nefpu|bnfpu)(tr?fvpug|xrxf|yrpxre|ybpu|jnemra?)?
    (qerpxf|fpurv&fmyvt;)?gfpuhfpu(ra)?(fnh)?
    nygre\f+fnpx
    nezyrhpugre
    onaxreg
    onfgneq
    orvqr?y(cenpxre)?
    ovgpu
    oy&bhzy;qznaa
    ohzfrerv
    qnezsybevfg
    qrcc
    qvyyb
    qbyz
    qerpxfnh
    qh\f+bcsre
    qhzzrewna
    qhzcsonpxr
    srggr\f+fnh
    srggfnpx
    srggfnh
    srgmr?afpu&nhzy;qry
    svpxr(a|e(rv)?)
    shpx
    shpxvat
    shg
    trfvpugffpunoenpxr
    trfvpugfibgmr
    uveav
    ubuyxbcs
    uhaqfsbgg
    uher
    uher?a(orvqr?y|xvaq|fbua)
    uhererv
    vqvbg
    vue\f+bcsref?
    whqraoratry
    whqrafnh
    xnanxra?
    xanyypunetr
    xanyyxbcs
    xbgmserffr
    y&hhzy;zzry
    yrpx\f+zvpu
    zvfgfg&hhzy;px
    avttre
    cvffre
    cengreuher?
    chqrenag
    chqrerv
    enhfpuxvaq
    fnpxenggr
    fnhwhqr?
    fpujnamyhgfpure
    fpujhpugry
    fpujhyr\f+fnh
    freivreshg
    fcnpxb
    fcnfgv?
    fg&hhzy;px\f+qerpx
    gnfpuraovyyneq
    gebggry
    hathfgr?y
    ibyyvqvbg
    ibyyxbssre
    ibgmr
    jv(kk?|puf)(re(rv)?|ibeyntr)
);

my $adj_dekl = "(e[mnrs]?)?";
my @adjectives = qw(
    (or|ire)(fpuvffra|xnpxg)
    (ibyy|na)tr(fpuvffra|xnpxg)
    oy&bhzy;q
    oynq
    oehamryaq
    qrccreg
    qbbs
    svfpuryaq
    cvffra
    fpurv(&fmyvt;|ff)
    ireqnzzg
    iresvpxg
    iresyhpug
    ireuheg
    gebggryvt
    iregebggryg
);


my $verb_dekl = '';
my @verbs = qw(
    nofcevgmra
    notrfcevgmg
    ohzfra
    oehamry?a
    svfpurya
    trsvpxg
    xvssra
    urehzuhera
    urehzfpujhpugrya
    chqrea
    fnhsra
);

tr/A-Za-z/N-ZA-Mn-za-m/ for @nouns, @verbs, @adjectives;

my @profanity = @nouns;

# verbs ending in -en or -ern can be made into adjectives by adding -d

push @profanity =>
    map { "$_$adj_dekl"  }
    @adjectives,
        map  { $_ . 'd' }
        grep { /er?n$/ }
        @verbs;

push @profanity =>
    map { "$_$verb_dekl" }
    @verbs;

my $assembler = Regexp::Assemble->new(flags => 'i');
for (@profanity) {
    decode_entities($_);
    $assembler->add($_);
}


# the '\x{'.'%s}' kludge is so it doesn't look like a template start tag

(my $profanity = $assembler->re) =~ s/(.)/
    ord($1) > 127
        ? sprintf('\x{'.'%s}', unpack("H*", pack("n", ord($1))))
        : $1
    /ge;

pattern name   => [ qw(at profanity) ],
        create => '(?:\b(?k:' . $profanity . ')\b)';

1;


__END__



=head1 NAME

Regexp::Common::AT::Profanity - provide regexes for profanity in Austrian German

=head1 SYNOPSIS

    use Regexp::Common 'AT::Profanity';

    while (<>) {
        /$RE{at}{profanity}/ and  print "Contains profanity\n";
    }

=head1 DESCRIPTION

This module defines patterns for profanity in Austrian German.

Please consult the manual of L<Regexp::Common> for a general description of
the works of this interface. Do not use this module directly, but load it
viaI<Regexp::Common>.

=head1 PATTERNS

=over 4

=item $RE{at}{profanity}

Provides a regex to match profanity in Austrian German. Note that correct
anatomical terms are deliberately I<not> included in the list, nor are those
words which also have genuinely non-offensive meanings.

Under C<-keep> (see L<Regexp::Common>):

=over 4

=item $1

captures the entire word

=back

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<regexpcommonatprofanity> tag.

=head1 VERSION 
                   
This document describes version 0.02 of L<Regexp::Common::AT::Profanity>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-regexp-common-at-profanity@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
