use Encode qw(decode encode);

#@List = Encode->encodings(":all");

$String = 'Радио';

$File = 'input.txt';
$FOut = 'all.txt';

open(FH, '<:encoding(UTF-8)', $File) or die "Cannot read from '$File': $!";
($String) = <FH>;
close(FH);

open(FO, "> :encoding(UTF-8)", $FOut) or die "Cannot write to $FOut: $!\n";
print FO "String: $String\n";
close(FO);

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

