use POSIX qw(strftime locale_h);
use Encode;

setlocale(LC_ALL, "ru_RU.utf8");
binmode(STDOUT, ":utf8");

#use locale ':not_characters';
#use open ':locale';

# use POSIX qw(locale_h);
# setlocale(LC_CTYPE, "ru_RU.ISO8859-5");

$File = shift or die "Usage: $0 <filename>\n";

open FH, '<:encoding(UTF-8)', $File or die "Can't open '$File' for reading: $!";


#open(FH,"<$File") or die "Cannot read $File\n";
@Lines = <FH>;
close(FH);
chomp(@Lines);

foreach (@Lines) {
	my $Str = decode_utf8($_);
	print "-> ", encode("cp437", $Str), "\n";
  if ($Tema) {
    print "$_\n";
	$Tema = 0;
	next;
  }
  if (/\s+<span>Тема:<\/span>/) {
    $Tema = 1;
  }
#	if (/Радио/) {
#		print $_, "\n";
#	}
#  unless (/\</) {
#		print ">> ", $_, "\n";
#	}

}