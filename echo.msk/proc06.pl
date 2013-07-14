#use feature 'unicode_strings';
#use utf8;
use encoding 'utf8';
use Encode qw(decode encode);

#@List = Encode->encodings(":all");

$File = 'input.txt';
$FOut = 'all.txt';

open(FH, '<:encoding(UTF-8)', $File) or die "Cannot read from '$File': $!";
@Lines = <FH>;
chomp(@Lines);
close(FH);

open(FO, "> :encoding(UTF-8)", $FOut) or die "Cannot write to $FOut: $!\n";

#my $raw = ('utf8', 'Радио');
my $Pattern = "Радио";
foreach (@Lines) {
  if (/$Pattern/) {
    print FO "Matches: ", $_, "\n";
  }
}


close(FO);
