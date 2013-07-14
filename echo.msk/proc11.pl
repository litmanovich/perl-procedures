#
# cd /D C:\Data\Storage\Recordings\EchoMsk
# perl proc11.pl echo.htm VseTak

use MP3::Tag;
use File::Copy;

$| = 1;

$Help = "Usage $0 <htm_file> <mp3_dir>";
$File = shift or die "$Help\n";
$InDir = shift or die "$Help\n";
$OutDir = $InDir . '_proc';
$ListFile = 'list.xspf';

if (-d $OutDir) {
  print "Directory $OutDir already exists\n";
} else {
  mkdir($OutDir) or die "Cannot mkdir $OutDir\n";
}

open(FH, "<$File") or die "Cannot open $File\n";
@Lines = <FH>;
close(FH);

open(FL, "<$ListFile") or die "Cannot open $ListFile\n";
@List = <FL>;
close(FL);

%RuMon = (
  'января'   => '01',
  'февраля'  => '02',
  'марта'    => '03',
  'апреля'   => '04',
  'мая'      => '05',
  'июня'     => '06',
  'июля'     => '07',
  'августа'  => '08',
  'сентября' => '09',
  'октября'  => '10',
  'ноября'   => '11',
  'декабря'  => '12',
);

# <div class="theme2">
# <span>Тема:</span>
# Матильда Английская - "династический товар" эпохи. Часть 2
# </div>
# ...
# <li class=""><a href="http://cdn.echo.msk.ru/snd/2013-06-15-vsetak-1807.mp3"

# <li class="first"><a href="http://cdn.echo.msk.ru/att/element-479837-snd1-Vse_tak_Rishelye_1.mp3" class="icInfo icDownload">скачать ч. 1 (3.6 МБ)</a></li>
# <li class=""><a href="http://cdn.echo.msk.ru/att/element-479837-snd2-Vse_tak_Rishelye_2.mp3" class="icInfo icDownload">скачать ч. 2 (5.5 МБ)</a></li>


# Join 2 mp3 files with VLC:
# "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" list01.xspf --sout "#transcode{acodec=mp3,ab=32,channels=2}:std{access=file,mux=raw,dst=merged.mp3}" --sout-keep


my ($File,@File,$NewFile,$Date);

foreach (@Lines) {

  if ($InDate) {
    if (/^\s*<span>(\d+)\s+(\S+)\s+(\d+)\,.+<\/span>/) {
      if (defined($RuMon{$2})) {
        $Date = "$3-$RuMon{$2}-$1";
      } else {
        die "ERROR: Unrecognized month: $2";
      }
    } elsif (/^\s*<\/div>/) {
      $InDate = 0;
    }
  } elsif (/\s*<div class="date">/) {
    $InDate = 1;
    next;
  }

  if ($InTheme) {
    if (/^\s*<\/div>/) {
      $InTheme = 0;
    } elsif (/<span>Тема\:<\/span>/) {
      # Ignore
    } else {
      s/^\s*//;
      s/\s*$//;
      $Title = $_;
      $File = undef;
      @File = ();
      $NewFile = undef;
    }
  } elsif (/^\s*<div class="theme2">/) {
    $InTheme = 1;
  } elsif ($Info2) {
    if (/^\s*<li class="\S*"><a href=\"http:\/\/cdn\.echo\.msk.ru\/snd\/(\S+\.mp3)\"/) {
      $File = $1;
    } elsif (/^\s*<li class="\S*"><a href=\"http:\/\/\d?\.?cdn\.echo\.msk.ru\/att\/(\S+\.mp3)\"/) {
      push(@File,$1);
    } elsif (/^\s*<\/ul>/) {
      if ($File) {
        $NewFile = copySndFile($File);
        undef($File);
      } elsif (@File) {
        $NewFile = copyAttFiles(@File);
        @File = ();
      }
      $Info2 = 0;
    }
  } elsif (/^\s*<ul class="info info2">/) {
    $Info2 = 1;
  }

  if ($NewFile) {
    # Add tags to MP3 file
    print "Setting MP3 tags in $OutDir/$NewFile\n";
    my $MP3 = MP3::Tag->new("$OutDir/$NewFile");
    $MP3->title_set($Title);
    $MP3->artist_set('Эхо Москвы');
    $MP3->album_set('Все так');
    $MP3->genre_set('История');
    $MP3->comment_set('Н.И. Басовская');
    $MP3->year_set($Year) if $Year;
    $MP3->track_set($Date) if $Date;
    $MP3->update_tags();
    $MP3->close();
    undef($MP3);
    undef($File);
    @File = ();
    undef($NewFile);
  }

}

exit 0;

sub copySndFile {
  my $File = shift;
  my $NewFile;
  # print "Processing $File : $Title\n";
  if (-f "$InDir/$File") {
    $NewFile = $File;
    my ($Year,$Date);
    if ($File =~ /(\d+)\-(\d+)\-(\d+)\-vsetak\-\d+\.mp3/) {
      $NewFile = "$1-$2-$3-vsetak.mp3";
      $Year = $1;
      $Date = "$1-$2-$3";
    }
    if (-f "$OutDir/$NewFile") {
      #print "File $OutDir/$NewFile already exists\n";
      return undef;
    }
    copy("$InDir/$File","$OutDir/$NewFile") or die "Cannot copy $InDir/$File to $OutDir/$NewFile: $!\n";
    return $NewFile;
  } else {
    #warn("Cannot find file $InDir/$File\n");
    return undef;
  }
}

sub copyAttFiles {
  my @File = @_;
  if ($Date) {
    # print "$Date\n";
    $NewFile = "$Date-vsetak.mp3";
    if (-f "$OutDir/$NewFile") {
      #print "File $OutDir/$NewFile already exists\n";
      return undef;
    }
    if (scalar(@File) == 1) {
      copy("$InDir/$File[0]","$OutDir/$NewFile") or die "Cannot copy $InDir/$File to $OutDir/$NewFile: $!\n";
      return $NewFile;
    } elsif (scalar(@File) == 2) {
      # print "Creating list for $OutDir/$NewFile\n";
      open (NL, ">$Date.xspf") or die "ERROR: Cannot write to $Date.xspf\n";
      foreach (@List) {
        my $Line = $_;
        $Line =~ s/---File01---/$InDir\/$File[0]/;
        $Line =~ s/---File02---/$InDir\/$File[1]/;
        print NL $Line;
      }
      close(NL);
      system(qq("C:\\Program Files (x86)\\VideoLAN\\VLC\\vlc.exe" $Date.xspf --sout "#transcode{acodec=mp3,ab=32,channels=2}:std{access=file,mux=raw,dst=$OutDir/$NewFile}" --sout-keep));
      return $NewFile;
    } else {
      print "ERROR: Cannot process more than 2 files\n";
    }
    #print "\n";
    undef($Date);
  } else {
    die "ERROR: Undetermined date for file $File[0]\n";
  }
  return undef;
}
