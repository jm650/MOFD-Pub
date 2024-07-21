#!/usr/bin/perl
#
# Jason Matthews
# 19Jul2024
# Kid tested, Mother approved


use Text::vCard::Precisely;
use Getopt::Std;
use File::Fetch;

my $vcard = Text::vCard::Precisely->new();
my $debug =0;
my $junk;
my %options=();
my $targetfile="bogon-team-roster.tsv";


getopts('df:o:ihu:', \%options);

if ( defined $options{i} && defined $options{o} ){  die "Cannot use both -i and -o at the sametime\n"; }


if ( defined $options{d} ){ $debug=1; }
if ( defined $options{f} ){ $targetfile=$options{f}; }

if ( defined $options{h} ){ &usage; }


sub usage{
   print "$0 -f specify an input file in tsv format downloaded from Google sheets\n";
   print "$0 -o specify an output file for a master record dump. One file, all records\n";
   print "$0 -i create individual files for each record\n";
   print "$0 -u download the sheet from Google sheets. Rrequires URL as an argument\n";
   print "$0 -h this handy message\n";
   print "Note that -i and -o cannot be used at the same time\n";
   print "Not supplying a source file will default to the bogon file in repo\n";
   print "Examples:\n\n";
   print "$0 -f ../../mofd-team-roster.tsv -o master.vcf\n";
   print "$0 -f../../mofd-team-roster.tsv -i\n";
   exit 0;
}



# -d enable debug mode
# -f specifies a real team roster file to read in lieu of the bogon file


open(my $fh, "<", $targetfile ) || die "Unable to open file, I pity the fool.\n\n";
$junk=<$fh>;
$junk=<$fh>;

while ( my $row = readline($fh) ) {
   ($tsvrow, $last,$first,$email,$cell,$home_phone,$address,$ham,$gmrs,$fema100,$fema200, 
   $fema700,$fema800,$cprexp,$faexp,$cert,$bios,$backpacks,$part107)=split(/\t/,$row);

# Try to normalize data
   $address =~ s/,//g;
   if   ( $address =~ /orinda/i )    { $city="Orinda";     $city =~ s/$address/Orinda"/i; }
   elsif ( $address =~ /moraga/i )    { $city="Moraga";    $city =~ s/$address/Moraga/i; $address=~s/moraga//i; }
   elsif ( $address =~ /lafayette/i ) { $city="Lafayette"; $city =~ s/$address/Lafayette/i; }

if ( $debug ) {
   print "\n---- DEBUG ----\nLine: $row\n";
   print "last: $last\nfirst: $first\nemail: $email\ncell:$cell\nhome:$home_phone\naddress: $address\nham:$ham\n";
   print "gmrs: $gmrs\nICS 100: $fema100\nICS 200: $fema200\nICS 700: $fema700\nICS 800: $fema800\nCity:$city\n";
   print "---- END DEBUG ----\n\n"

}


   $note="MOFD Support Team\nHAM Callsign: $ham\nGMRS Callsign: $gmrs\nIC 100: $fema100\nIC 200: $fema200\nIC 700: $fema700\nIC 800: $fema800\nCERT: $cert\n";

   $vcard->n([$last,$first, ,'','']);
   $vcard->fn("$first $last");
   $vcard->note($note);
   $vcard->email($email);
   $vcard->tel( 
        { type=>['CELL','VOICE'], content => "$cell" }
      );
   $vcard->adr( {
      type   =>['home'],
      street => $address,
      city   => $city,
      region => "LaMOrinda",
      country => "United States of America"
      }
   );
   if ( defined $options{i} ){ 
      open ( my $outfile, ">", "$first.$last.vcf" );
      print $outfile  $vcard->as_string;
      close $outfile; 
      }
   elsif (defined $options{o}) {
      my $record=$vcard->as_string;
      $master_vcard="$master_vcard"."$record";
   }
   else {
      print $vcard->as_string;
      }
}

if ( defined $options{o} ){
	open (my $master, ">", "$options{o}" );
	print $master $master_vcard;
	close $master;
}


