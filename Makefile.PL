use inc::Module::Install;

name 'Catalyst-Plugin-Session-Store-BerkeleyDB';
all_from 'lib/Catalyst/Plugin/Session/Store/BerkeleyDB.pm';

requires 'BerkeleyDB::Manager';
requires 'Catalyst::Runtime';
requires 'Catalyst::Plugin::Session';
requires 'Class::Data::Inheritable';
requires 'File::Remove';
requires 'Scalar::Util';
requires 'Storable';
requires 'namespace::clean';

build_requires 'Directory::Scratch';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
