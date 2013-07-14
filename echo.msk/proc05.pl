use Encode qw(decode encode);

@List = Encode->encodings(":all");

$FOut = 'all.txt';

open(FO, "> :encoding(UTF-8)", $FOut) or die "Cannot write to $FOut: $!\n";

foreach my $Encoding (@List) {
  print FO "$Encoding\n";
  my $StrEnc = quotemeta(encode($Encoding, 'Радио'));
  print FO "   ", $StrEnc, "\n";
  my $StrDec = quotemeta(decode($Encoding, 'Радио'));
  print FO "   ", $StrDec, "\n";
}

close(FO);
