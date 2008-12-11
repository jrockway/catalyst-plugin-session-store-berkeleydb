package TestApp::Controller::Root;
use strict;
use warnings;

__PACKAGE__->config(namespace => q{});

use base 'Catalyst::Controller';

# your actions replace this one
sub main :Path { $_[1]->res->body('<h1>It works</h1>') }

sub session_test :Local {
    my ($self, $c) = @_;
    $c->session->{value} ||= 0;
    $c->res->body( join ',', $c->sessionid, $c->session->{value}++ );
}

sub delete :Local {
    my ($self, $c) = @_;
    $c->delete_expired_sessions;
    $c->res->body( 'ok' );
}

1;
