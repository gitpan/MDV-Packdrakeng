# $Id: Makefile.PL,v 1.2 2005/10/28 12:17:38 rgarciasuarez Exp $

use 5.008;
use strict;
use ExtUtils::MakeMaker;

# where to find the rpm utility
my $rpm_path = $ENV{RPM_PATH}; # this overrides
unless (defined $rpm_path) {
    for (qw(/bin/rpm /usr/bin/rpm)) {
	if (-x) {
	    $rpm_path = $_;
	    last;
	}
    }
}
my $rpmtopdir = $rpm_path ? `$rpm_path --eval '%{_topdir}'` : '';
chomp $rpmtopdir;

sub MY::postamble {
    <<MAKE;
.PHONY: ChangeLog rpmdist srpm rpm

ChangeLog: ../common/username
	cvs2cl -W 400 -I ChangeLog --accum -U ../common/username
	rm -f *.bak

rpmdist: dist
	cp -f perl-MDV-Packdrakeng.spec $rpmtopdir/SPECS
	bzme MDV-Packdrakeng-*.tar.gz
	mv -f MDV-Packdrakeng-*.tar.bz2 $rpmtopdir/SOURCES

srpm: rpmdist
	rpmbuild -bs --clean --rmsource $rpmtopdir/SPECS/perl-MDV-Packdrakeng.spec

rpm: rpmdist
	rpmbuild -ba --clean --rmsource $rpmtopdir/SPECS/perl-MDV-Packdrakeng.spec
MAKE
}

WriteMakefile(
    NAME	 => 'MDV::Packdrakeng',
    VERSION_FROM => 'lib/MDV/Packdrakeng.pm',
);
