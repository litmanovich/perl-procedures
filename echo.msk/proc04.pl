use Encode qw(decode encode);

@List = Encode->encodings(":all");

#$String = encode('UTF-8', 'Радио');


$File = 'input.txt';
$FOut = 'all.txt';

open(FH, '<:encoding(UTF-8)', $File) or die "Cannot read from '$File': $!";
@Lines = <FH>;
chomp(@Lines);
close(FH);

open(FO, "> :encoding(UTF-8)", $FOut) or die "Cannot write to $FOut: $!\n";
print FO "String: $_\n" for @Lines;
close(FO);

foreach my $Encoding (@List) {
  my $StrEnc = quotemeta(encode($Encoding, 'Радио'));
  my $StrDec = quotemeta(decode($Encoding, 'Радио'));
  foreach my $Line (@Lines) {
    if ($Line =~ /$StrEnc/) {
      print "Encoded matches $Encoding: ", $Line, "\n";
    }
    if ($Line =~ /$StrDec/) {
      print "Decoded matches $Encoding: ", $Line, "\n";
    }
  }
}

#$infile = 'input.txt';
#$outfile = 'all.txt';
#
#open(INPUT,  "< :encoding(UTF-8)", $infile) || die "Can't open < $infile for reading: $!";
#open(OUTPUT, "> :encoding(UTF-8)",  $outfile) || die "Can't open > $outfile for writing: $!";
#while (<INPUT>) {   # auto decodes $_
#  print OUTPUT;   # auto encodes $_
#}
#close(INPUT)   || die "can't close $infile: $!";
#close(OUTPUT)  || die "can't close $outfile: $!";


#foreach my $Enc (@List) {
#  my $Decoded = decode($Enc, $String);
#  print "Decoded $Enc: $Decoded\n";
#  my $Encoded = encode($Enc, $String);
#  print "Encoded $Enc: $Encoded\n";
#}

