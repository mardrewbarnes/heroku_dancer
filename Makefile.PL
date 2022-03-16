use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'app.pl',
  VERSION      => '1.0',
  AUTHOR       => 'Daniele Piccone <mail@danielepiccone.com>',
  EXE_FILES    => ['app.pl'],
  PREREQ_PM    => {'Dancer' => '1.0', 'JSON::XS' => '4.03'},
  test         => {TESTS => 't/*.t'}
);

