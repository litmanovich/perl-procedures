#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(strftime locale_h);
use Encode;

setlocale(LC_ALL, "ru_RU.utf8");

my @months;
for (0..11)
{
      my $utf8_name = strftime("%B", 0, 0, 0, 1, $_, 100);
      $months[$_] = decode_utf8($utf8_name);
}

#binmode(STDOUT, ":utf8");
binmode STDOUT, ':encoding(utf8)';

for my $i (0..11)
{
      print "$i: $months[$i]\n";
}