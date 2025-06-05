#!/usr/bin/perl
use 5.16.0;
use warnings FATAL => 'all';
use POSIX ":sys_wait_h";

use Time::HiRes qw(time);
use Test::Simple tests => 6;

my @BINS = qw(dynarray);
my @OBJS = glob("*.o");
my @BADS = (@BINS, @OBJS);
my $unclean = 0;
for my $file (@BADS) {
    if (-e "$file") {
        say("# UNCLEAN! Found $file");
        $unclean = 1;
    }
}
ok(!$unclean, "no binaries");

system("(make 2>&1) > /dev/null");

sub get_time {
    my $data = `cat time.tmp | grep ^real`;
    $data =~ /^real\s+(.*)$/;
    return 0 + $1;
}

sub run_prog {
    my ($prog, $arg) = @_;
    system("rm -f outp.tmp time.tmp");
    system("timeout -k 30 20 time -p -o time.tmp ./$prog $arg > outp.tmp");
    return `cat outp.tmp`;
}

my $arg_2 = run_prog("dynarray", "ab");
ok($arg_2 =~ /number of reallocs: 1/, "dynarray 2");

my $arg_3 = run_prog("dynarray", "abc");
ok($arg_3 =~ /number of reallocs: 1/, "dynarray 3");

my $arg_4 = run_prog("dynarray", "abcd");
ok($arg_4 =~ /number of reallocs: 2/, "dynarray 4");

my $arg_16 = run_prog("dynarray", "abcdefghijklmnop");
ok($arg_16 =~ /number of reallocs: 4/, "dynarray 16");

my $arg_17 = run_prog("dynarray", "abcdefghijklmnopq");
ok($arg_17 =~ /number of reallocs: 4/, "dynarray 17");

system("(make clean 2>&1) > /dev/null");
