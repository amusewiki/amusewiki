#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use lib 'lib';
use AmuseWikiFarm::Schema;
use File::Spec::Functions qw/catfile catdir/;
use Cwd;
use Getopt::Long;

binmode STDOUT, ":encoding(utf-8)";

my $gitpath = '/var/cache/git/';

GetOptions('gitpath=s' => \$gitpath);

my $schema = AmuseWikiFarm::Schema->connect('amuse');

print "####### automatically generated on " . localtime() . " ######\n\n";

foreach my $site ($schema->resultset('Site')->all) {
    next unless $site->cgit_integration;
    my $path = $gitpath . $site->id . ".git";
    print "repo.url=" . $site->id . "\n";
    print "repo.path=" . $path . "\n";
    print "repo.desc=" . $site->sitename . "\n";
    print "\n\n";
}

print "####### end of automatically generated config ######\n\n";