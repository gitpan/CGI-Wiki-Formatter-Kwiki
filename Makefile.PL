    use ExtUtils::MakeMaker;
    WriteMakefile
      ('DISTNAME' => 'CGI-Wiki-Formatter-Kwiki',
       'VERSION' => '0.01',
       'PL_FILES' => {},
       'PREREQ_PM' => {
			'Test::Simple' => '0',
			'CGI::Wiki' => '0',
			'CGI::Kwiki' => '0',

		      },
      );
