#!/usr/bin/perl
#
# getWundergroundData
#  - this retrieves Weather Underground data from
#     the specified StationID and reformats it into
#     comma-delimited format intended for import
#     (after separate external reformatting) into
#     wview historical archive databases
#
# To run behind a proxy, set an external HTTP_proxy 
# environmentvariable to the fully qualified URL that
# matches your site.
#  ex: export HTTP_proxy="http://some.example.com:8080"
#
# run "perl thisFileNmae" without options for usage
#
# Changelog:
#   2009-0321 - vince@skahan.net - original
#

use utf8;
use 5.006000;
use strict;
use warnings;

use Weather::Underground::StationHistory qw{ :all };
use LWP::Simple qw( $ua get );
use Getopt::Long;

my $nl="\n";

# days per month
#  - no harm in leap-year
my %days = ( 1,31 , 2,29 , 3,31 , 4,30 , 5,31 , 6,30 , 7,31 , 8,31 , 9,30 , 10,31 , 11,30 , 12,31);

# get command-line options
my ($opt_day, $opt_month, $opt_year,$opt_station,$opt_proxy,$opt_verbose,$opt_test);
my $options_ok = GetOptions (
	'day=s'     => \$opt_day,
	'month=i'    => \$opt_month,
	'year=i'     => \$opt_year,
	'station=s' => \$opt_station,
	'verbose'   => \$opt_verbose,
	'test'      => \$opt_test,
);

#####################################################
# usage message
#####################################################

sub printUsage {
	
print <<EOF;
#
# Usage:
# ======
# $0 -s [stationId] mandatory_parameters optional_parameters
#
# mandatory paramaters:
#       -d yyyymmdd = one date (20081231)
#       -m yyyymm   = one month (200812)
#       -y yyyy     = entire year of months (2008)
#
# optional parameters:
#     -t             = test/debug only
#
#   Example:
#   ========
#     $0 -s MYSTATIONID -m 200812
#       to get Dec-2008 and save to 2008-12.csv
#
EOF
  exit 1;

}

#####################################################
# get and clean up a Wunderground history page
#####################################################

sub getWundergroundRecord {
	my ($stationId,$yyyy,$mm,$dd) = @_;
	my $expected_datestring = "$yyyy-$mm-$dd";

	my $url = generate_single_day_station_history_url(
		"$stationId", "$yyyy", "$mm", "$dd");

	###print "url=$url\n";

	# get( ) returns undefined if the get is unsuccessful
	my $supposed_csv = get($url);
	unless (defined $supposed_csv) {
		print $nl;
		print "#### WARNING - can't get web page for $yyyy-$mm-$dd (need a proxy?)", $nl;
		print $nl;
		return;
	}

	# clean up the output
	my $stripped_csv = strip_garbage_from_station_history($supposed_csv);

	# wunderground does not always return just today's data
	my @original_lines      = split m/ [\r\n]+ /xms, $stripped_csv;
	foreach my $line (@original_lines) {
		next unless ($line =~ /$expected_datestring/);
		print "$line" , $nl;
	}

}

#####################################################
# main below here
#####################################################

unless ($opt_station) {
	print $nl, "##### ==> exiting: must specify -s <==" , $nl, $nl;
	printUsage();
}

if ($opt_day)     { 
	if (length($opt_day) ne "8") { 
		print STDERR $nl, "==> ERROR: opt_day must be yyyymmdd - exiting <==" , $nl, $nl;
		printUsage();
		exit 1
	}
	# format 20081231
	my $yyyy = substr($opt_day,0,4);
	my $mm   = substr($opt_day,4,2);
	my $day  = substr($opt_day,6,2);
	print STDERR "getting $yyyy-$mm-$day\n";
	unless ($opt_test) { getWundergroundRecord($opt_station,$yyyy,$mm,$day); }
} elsif ($opt_month) {
	if (length($opt_month) ne "6") { 
		print STDERR $nl, "==> ERROR: opt_month must be yyyymm - exiting <==" , $nl, $nl;
		printUsage();
		exit 1
	}
	# format 20081231
	my $yyyy = substr($opt_month,0,4);
	my $mm   = substr($opt_month,4,2);
	my $m = int($mm);   # hash is keyed to months with no leading zeroes
	my $day;
	print STDERR "getting $yyyy-$mm\n";
	my $file="$yyyy-$mm.csv";
	open (STDOUT,">$file") or die "can't open $file for write: $!\n";
	foreach my $d (1..$days{$m}) {
		if ($d <10) { $day = "0$d";} else { $day = $d; }
		print STDERR "   $day\n";
		unless ($opt_test) { getWundergroundRecord($opt_station,$yyyy,$mm,$day); }
	}
	close(STDOUT);
} elsif ($opt_year) {
	if (length($opt_year) ne "4") { 
		print STDERR $nl, "==> ERROR: opt_year must be yyyy - exiting <==" , $nl, $nl;
		printUsage();
		exit 1
	}
	# format 20081231
	# format 2008
	my $yyyy = substr($opt_year,0,4);
	my $mm;
	my $day;
	foreach my $m (1..12) {
		if ($m <10) { $mm = "0$m"; } else { $mm = $m; }
		print STDERR "getting $yyyy-$mm\n";
		my $file="$yyyy-$mm.csv";
		open (STDOUT,">$file") or die "can't open $file for write: $!\n";
		foreach my $d (1..$days{$m}) {
			if ($d <10) { $day = "0$d";} else { $day = $d; }
			print STDERR "   $day\n";
			unless ($opt_test) {getWundergroundRecord($opt_station,$yyyy,$mm,$day); }
		}
		close(STDOUT);
	}
} else {
	print $nl, "##### ==> exiting: must specify one of -d -m or -y <==" , $nl, $nl;
	printUsage();
}

__DATA__
