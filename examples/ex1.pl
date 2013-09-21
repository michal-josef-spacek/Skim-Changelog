#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use Skim::Changelog;

# Object.
my $obj = Skim::Changelog->new;

# Example structure.
my $struct_hr = {
        '0.01' => {
                'date' => [1, 1, 2013],
                'items' => [
                        'foo',
                        join ' ', ('bar') x 50,
                ],
        },
        '0.02' => {
                'date' => [],
                'items' => [
                        'unreleased',
                ],
        },
};

# Serialize.
my $skim_changelog = $obj->serialize($struct_hr);

# Print out.
print $skim_changelog;

# Output:
# 0.02
# - unreleased
# 
# 0.01 (January 1, 2013)
# - foo
# - bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar
#   bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar bar
#   bar bar bar bar bar bar bar bar bar bar bar bar