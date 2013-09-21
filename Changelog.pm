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

__END__

=pod

=encoding utf8

=head1 NAME

Skim::Changelog - Perl class for processing Skim's changelog.

=head1 SYNOPSIS

 use Skim::Changelog;
 my $obj = Skim::Changelog->new(%params);
 my $struct_hr = $obj->parse($skim_changelog);
 my $skim_changelog = $obj->serialize($struct_hr);

=head1 METHODS

=over 8

=item C<new(%params)>

 Constructor.

=item C<parse($skim_changelog)>

 Parse $skim_changelog data.
 Returns hash reference to structure with parsed data.

=item C<serialize($struct_hr)>

 Serialize hash reference with structure.
 Returns array of lines in array context.
 Returns Changes string in scalar context.

=back

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE

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

=head1 DEPENDENCIES

L<Class::Utils>,
L<Date::Calc>,
L<Indent::String>,
L<Readonly>.

=head1 SEE ALSO

L<CPAN::Changes>,
L<CPAN::Changes::SPEC>.

=head1 REPOSITORY

L<https://github.com/tupinek/Skim-Changelog>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
