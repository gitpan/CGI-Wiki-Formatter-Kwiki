use Module::Build;
my $build = Module::Build->new(
    module_name => 'CGI::Wiki::Formatter::Kwiki',
    license => 'perl',
    requires => {
        'perl'        => '5.6.0',
        'CGI::Wiki'   => 0,
        'CGI::Kwiki'  => 0,
        'Test::More'=> 0,
    },
    create_makefile_pl => 'traditional',
);
$build->create_build_script;

