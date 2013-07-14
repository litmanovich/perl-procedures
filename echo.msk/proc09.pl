# Convert encoding from cp1251 to utf8 in all files of specified directory

#use encoding 'utf8';
use Encode qw(decode encode);
use File::Find;
use File::Basename;
use File::Path qw(make_path);

$Help = "Usage $0 <indir>\n";
$InDir = shift or die $Help;
$OutDir = $InDir . '_utf8';

-d $OutDir and die "Directory $OutDir already exists\n";
-d $InDir or die "Cannot find $InDir\n";

find(\&fillNames, $InDir);

foreach (@Names) {
  (my $NewFile = $_) =~ s/^${InDir}/${OutDir}/e;
  my $Dir = dirname($NewFile);
  make_path($Dir) unless -d $Dir;
  print "Translating $_\n";
  open(F, "<:encoding(cp1251)", $_)       or die $!;
  open(G, ">:utf8",             $NewFile) or die $!;
  while (<F>) { print G }
  close(F);
  close(G);
}

exit 0;

sub fillNames {
  push (@Names, $File::Find::name) if -f;
}
