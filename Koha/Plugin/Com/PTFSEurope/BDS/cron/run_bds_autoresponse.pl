#!/usr/bin/perl

# This file is part of Koha.
#
# Copyright (C) 2022 PTFS Europe
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;
use Getopt::Long qw( GetOptions );
use Koha::Script;
#use Koha::Illrequests;
use Koha::Plugins;
use Data::Dumper;

# Command line option values
my $get_help = 0;
my $dry_run = 0;
my $debug = 0;
my $env = "dev";
my $toolphase = "";

my $options = GetOptions(
    'h|help'            => \$get_help,    
    'dry-run'           => \$dry_run,
    'debug'             => \$debug,
    'env=s'             => \$env,
    'toolphase:s'       => \$toolphase
);

if ($get_help) {
    get_help();
    exit 1;
}

our $logger =
  Koha::Logger->get( { interface => 'intranet', category => 'test' } );

# First check we can proceed
my @bds_plugin = Koha::Plugins->new()->GetPlugins( {'metadata' => {'name'=>'BDS Marc Record Integrator'} } );
my $bds = $bds_plugin[0];
use Data::Dumper; $Data::Dumper::Maxdepth = 2;
warn Dumper('##### 1 #######################################################line: ' . __LINE__);
warn Dumper($bds->submit_bds(1));
warn Dumper('##### end1 #######################################################');
if(!$bds)  {
  $logger->warn("No BDS plugin installed. Cron bailing...\n");
  exit 0;
}
#  toolphase specified, run only this toolphase
if ($toolphase eq "submit") {
   warn Dumper($bds->submit_bds(1));
}
elsif ($toolphase eq "import") {
   warn Dumper($bds->import_bds(1));
}
elsif ($toolphase eq "stage") {
   warn Dumper($bds->stage_bds(1));
}
else {
      $logger->warn("Incorrect tool phase parameter supplied of $toolphase to BDS plugin via cron. Not running...\n");
}

sub debug_msg {
    my ( $msg ) = @_;

    if (!$debug) {
        return;
    }

    if (ref $msg eq 'HASH') {
        use Data::Dumper;
        $msg = Dumper $msg;
    }
    print STDERR "$msg\n";
}

sub get_help {
    print <<"HELP";
$0: Run a BDS autoresponse phase

This script will run backend-wide toolphases provided by the Backend.
Example: the ReprintsDesk backend provides a toolphase script
that queries the supplier for the most recent 100 orders and acts 
upon the response.

Parameters:
    --toolphase                          tool to run - submit, import or stage are the options
    --dry-run                            only produce a run report, without actually doing anything permanent
    --debug                              print additional debugging info during run
    --env                                prod/dev - defaults to dev if not specified
    --help or -h                         get help
HELP
}

