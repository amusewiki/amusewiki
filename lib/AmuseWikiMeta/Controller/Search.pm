package AmuseWikiMeta::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use AmuseWikiFarm::Log::Contextual;
use AmuseWikiFarm::Archive::Xapian;
use AmuseWikiFarm::Utils::Paginator;
use Path::Tiny;

sub search :Chained('/root') :PathPart('search') :Args(0) {
    my ($self, $c) = @_;
    # here instead of a directory, we pass a stub database, named xapian.stub
    my $stub = $ENV{AMW_META_XAPIAN_DB} ?
      path($ENV{AMW_META_XAPIAN_DB}) :
      path($c->stash->{amw_meta_root}, 'xapian.stub');
    die "Cannot proceed without $stub stub database" unless -f $stub;
    my $xapian = AmuseWikiFarm::Archive::Xapian->new(multisite => 1,
                                                     stub_database => "$stub",
                                                    );
    my %params = %{$c->req->params};

    my @sites = $c->model('DB::Site')->public_only;
    my $res = $xapian->faceted_search(%params,
                                      facets => 0,
                                      filters => 1,
                                     );

    my $baseres = $xapian->faceted_search(%params,
                                          filters => 0,
                                          facets => 1);
    my $site_map = { map { $_->id => $_->canonical_url } @sites };

    $baseres->sites_map($site_map);
    $res->sites_map($site_map);
    $baseres->languages_map($sites[0]->known_langs);

    my $pager = AmuseWikiFarm::Utils::Paginator::create_pager($res->pager, sub { $_[0] });

    $c->stash(json => {
                       matches => $res->json_output,
                       filters => $baseres->facet_tokens,
                       pager_needed => $pager->needed,
                       pager => $pager->items,
                      });
    Dlog_debug { "json is $_" } $c->stash->{json};
}

__PACKAGE__->meta->make_immutable;

1;