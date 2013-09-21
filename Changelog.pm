package Skim::Changelog;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Date::Calc qw(Decode_Month);
use Readonly;

# Constants.
Readonly::Scalar our $EMPTY_STR => q{};

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Process parameters.
	set_params($self, @params);

	# Object.
	return $self;
}

# Parse.
sub parse {
	my ($self, $data) = @_;
	my $struct_hr = {};
	my $last_version;
	foreach my $line (split m/\n/ms, $data) {

		# Version.
		if ($line =~ m/^([\d\.]+)\s*\(?([^\)]*)\)?\s*$/ms) {
			$last_version = $1;
			$struct_hr->{$last_version} = {
				'date' => $self->_parse_date($2),
				'items' => [],
			};

		# Item.
		} elsif ($line =~ m/^-\s+(.*)$/ms) {
			push @{$struct_hr->{$last_version}->{'items'}}, $1;

		# Item continues.
		} elsif ($line =~ m/^\s*$/ms && $line =~ m/^\s+(.*)$/ms) {
			$struct_hr->{$last_version}->{'items'}->[-1] .= $SPACE.$1;
		}
	}
	return $struct_hr;
}

# Serialize to text string.
sub serialize {
	my ($self, $struct_hr) = @_;
	# TODO
	return '';
}

# Parse date.
sub _parse_date {
	my ($self, $date) = @_;
	if (! defined $date || ! $date) {
		return [];
	}
	my ($month_day, $year) = split m/,\s+/ms, $date;
	my ($month, $day) = split m/\s+/ms, $month_day;
	return [$day, Decode_Month($month), $year];
}

1;
