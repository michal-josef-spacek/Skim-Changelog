package Skim::Changelog;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Date::Calc qw(Decode_Month Month_to_Text);
use Indent::String;
use Readonly;

# Constants.
Readonly::Scalar our $COMMA => q{,};
Readonly::Scalar our $EMPTY_STR => q{};
Readonly::Scalar our $SPACE => q{ };

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
		} elsif ($line !~ m/^\s*$/ms && $line =~ m/^\s+(.*)$/ms) {
			$struct_hr->{$last_version}->{'items'}->[-1] .= $SPACE.$1;
		}
	}
	return $struct_hr;
}

# Serialize to text string.
sub serialize {
	my ($self, $struct_hr) = @_;
	my @ret;
	my $indent = Indent::String->new(
		'line_size' => 77,
		'next_indent' => $SPACE x 2,
	);
	foreach my $version (reverse sort keys %{$struct_hr}) {
		my $version_line = $version;
		if (@{$struct_hr->{$version}->{'date'}} > 0) {
			$version_line .= ' ('.$self->_serialize_date(
				@{$struct_hr->{$version}->{'date'}}).')';
		}
		push @ret, $version_line;
		foreach my $item (@{$struct_hr->{$version}->{'items'}}) {
			push @ret, '- '.$indent->indent($item);
		}
		push @ret, $EMPTY_STR;
	}
	return wantarray ? @ret : join "\n", @ret;
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

# Serialize date.
sub _serialize_date {
	my ($self, $day, $month, $year) = @_;
	return Month_to_Text($month).$SPACE.$day.$COMMA.$SPACE.$year;
}

1;
