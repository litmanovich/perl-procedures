use encoding 'utf8';
#use Encode qw(decode encode);
use Tk;

$File = 'input.txt';
$String = '';

open(FH, '<:encoding(UTF-8)', $File) or die "Cannot read from '$File': $!";
@Lines = <FH>;
chomp(@Lines);
close(FH);

$mw = MainWindow->new( );
#$Lbl = $mw->Label(
#    -text => "Радио",
#    -textvariable => \$String,
#  );

$mw->Entry(
    -textvariable    => \$String,
  )->pack(-expand => 1, -fill => 'x');

#$Lbl->pack( );

$Text = $mw->Scrolled(
    "Text",
    -width => 50,
    -height => 30,
    -scrollbars => 'osoe',
  )->pack( );

$Text->insert('end', "$_\n") for @Lines;

$mw->Button(-text => "Ok", -command => \&matchLines)->pack( );

MainLoop;

exit 0;

sub matchLines {
  return unless defined($Text);
  $Text->delete("1.0", 'end');
  my @Match = grep {/$String/i} @Lines;
  $Text->insert('end', "$_\n") for @Match;
}
