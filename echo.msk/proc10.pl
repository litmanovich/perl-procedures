#

#use encoding 'utf8';
use MP3::Tag;

#use Encode qw(decode encode);
#use File::Find;
#use File::Basename;
#use File::Path qw(make_path);

$Help = "Usage $0 <mp3file>";
$File = shift or die "$Help\n";

$MP3 = MP3::Tag->new($File);
#($title, $track, $artist, $album, $comment, $year, $genre) = $MP3->autoinfo();

$MP3->title_set('Матильда Английская - династический товар эпохи - Часть 1');
$MP3->artist_set('Эхо Москвы');
$MP3->album_set('Все так');

$MP3->update_tags();

#print "$_\n" for $MP3->autoinfo();

exit 0;
