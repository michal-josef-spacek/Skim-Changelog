# Pragmas.
use strict;
use warnings;

# Modules.
use Skim::Changelog;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Skim::Changelog::VERSION, 0.01, 'Version.');
