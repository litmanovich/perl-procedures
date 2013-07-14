use encoding 'utf8';
use Encode qw(decode encode);

$FileIn = shift or die "Usage: $0 <filename>\n";
$FileOut = $FileIn;
$FileOut =~ s/(\.[^\.]+)$/_utf$1/ or die "Cannot compose output filename\n";

open(F, "<:encoding(cp1251)",    $FileIn)  or die $!;
open(G, ">:utf8",                 $FileOut) or die $!;
while (<F>) { print G }
close(F);
close(G);

exit 0;
