package Catalyst::Plugin::Session::Store::BerkeleyDB;
use strict;
use warnings;

use BerkeleyDB;
use BerkeleyDB::Manager;
use Storable qw(nfreeze thaw);
use Scalar::Util qw(blessed);
use Catalyst::Utils;
use namespace::clean;

our $VERSION = '0.01';

use base 'Class::Data::Inheritable', 'Catalyst::Plugin::Session::Store';

my $_manager = '_session_store_manager';
my $_db = '_session_store_database';

__PACKAGE__->mk_classdata($_manager);
__PACKAGE__->mk_classdata($_db);

sub setup_session {
    my $app = shift;

    my $manager = $app->config->{session}{manager} || +{
        home => Path::Class::Dir->new(
            Catalyst::Utils::class2tempdir($app), 'sessions',
        ),
        create => 1,
    };

    my $db = $app->config->{session}{database} || 'catalyst_sessions';

    if(!blessed $manager){
        $manager = BerkeleyDB::Manager->new( $manager );
    }

    if(!blessed $db){
        $db = $manager->open_db( $db );
    }

    $app->$_manager($manager);
    $app->$_db($db);
}

sub get_session_data {
    my ($c, $id) = @_;

    my $data;
    my $status = $c->$_db->db_get($id, $data);

    if($data && !$status) {
        if($id =~ /^expires:/){
            return $data;
        }
        return thaw($data);
    }
    return {};
}

sub store_session_data {
    my ($c, $id, $data) = @_;
    my $frozen = ref $data ? nfreeze($data) : $data;
    $c->$_db->db_put($id, $frozen);
}

sub delete_session_data {
    my ($c, $id) = @_;
    $c->$_db->db_del($id);
}

sub delete_expired_sessions {
    my($c, $id) = @_;
    my $manager = $c->$_manager;
    my $db = $c->$_db;

    $manager->txn_do(sub {
        my ($key, $value) = ("", "");

        # find out what we need to delete
        my %to_delete;
        my $all = $db->db_cursor;
        while( 0 == $all->c_get( $key, $value, DB_NEXT ) ){
            if($key =~ /^expires:(.+)$/){
                $to_delete{$1} = 1 if time > $value;
            }
        }

        # then delete all of those
        $all = $db->db_cursor;
        while( 0 == $all->c_get( $key, $value, DB_NEXT ) ){
            my ($name, $id) = split /:/, $key;
            $all->c_del() and warn "bye, $key" if $to_delete{$id};
        };
    });
}

1;

__END__

=head1 NAME

Catalyst::Plugin::Session::Store::BerkeleyDB - store sessions in a berkeleydb

