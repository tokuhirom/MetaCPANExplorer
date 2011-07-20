package MetaCPANExplorer::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new;

any '/' => sub {
    my ($c) = @_;

    my %stash;

    if (my $url = $c->req->param('url')) {
        if ($url =~ m{^/}) {
            my $content = $c->req->param('content');
            my $res = do {
                if (length $content) {
                    $ua->post("http://api.metacpan.org$url", Content => $content);
                } else {
                    $ua->get("http://api.metacpan.org$url");
                }
            };
            $stash{res} = $res;
        }
    }

    $c->fillin_form($c->req);
    $c->render('index.tt', \%stash);
};

1;
