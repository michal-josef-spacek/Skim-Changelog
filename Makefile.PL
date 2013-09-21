# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl class for processing Skim\'s changelog.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Skim-Changelog';
requires 'Class::Utils' => 0.03;
requires 'Date::Calc' => 0;
requires 'Indent::String' => 0.01;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Skim-Changelog';
resources 'homepage' => 'https://github.com/tupinek/Skim-Changelog';
resources 'repository' => 'git://github.com/tupinek/Skim-Changelog';
test_requires 'File::Object' => 0.05;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
