package TestApp;
use strict;
use warnings;

use Catalyst qw/Session Session::State::Cookie Session::Store::BerkeleyDB/;

__PACKAGE__->config( session => {
    expires => 50,
});

__PACKAGE__->setup;

1;
