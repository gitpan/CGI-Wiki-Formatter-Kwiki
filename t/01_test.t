use warnings;
use strict;

use CGI::Wiki::Formatter::Kwiki;
use Test::Simple tests=>5;

my $input = "";
my $output = "";
my $test = "";

my $formatter = CGI::Wiki::Formatter::Kwiki->new();

ok($formatter);

{
    local $/=undef;
    open INPUT, "t/input";
    open OUTPUT, "t/output";
    $input = <INPUT>;
    $output = <OUTPUT>;
    close INPUT;
    close OUTPUT;
}

$test = $formatter->format($input);

ok($input);
ok($output);
ok($test);

ok($output eq $test);
