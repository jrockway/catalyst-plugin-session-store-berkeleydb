use inc::Module::Install;

name 'Catalyst-Plugin-Session-Store-BerkeleyDB';
all_from 'lib/Catalyst/Plugin/Session/Store/BerkeleyDB.pm';

build_requires 'Catalyst::Runtime';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
