
VERSION=1.1
SCRIPT=stendhalws
PACKAGE=stendhal-webstart
DISTNAME=$(PACKAGE)_$(VERSION)
DISTPACKAGE=$(DISTNAME).tar.xz

prefix=/usr/local

BINDIR=games
DATAROOT=share
APPDIR=$(DATAROOT)/applications
PIXDIR=$(DATAROOT)/pixmaps

INSTALL_DATA = install -vm 0644
INSTALL_EXEC = install -vm 0755
UNINSTALL = rm -vf
MKDIR = mkdir -vp

INSTALLFILES = \
	$(SCRIPT) \
	$(PACKAGE).png \
	$(PACKAGE).desktop \

DISTFILES = \
	$(INSTALLFILES) \
	Makefile \
	README.md

DISTDIRS = \
	debian

DEBUILD_FILES= \
	debian/files \
	debian/debhelper-build-stamp \
	debian/stendhal-webstart.debhelper.log \
	debian/stendhal-webstart.substvars \


all:
	@echo "\n\tNothing to be done"; \
	echo "\trun `tput bold`make install`tput sgr0`\n"; \

install:
	@target=$(DESTDIR)$(prefix); \
	bindir=$${target}/$(BINDIR); \
	appdir=$${target}/$(APPDIR); \
	pixdir=$${target}/$(PIXDIR); \
	$(MKDIR) "$${bindir}" "$${pixdir}" "$${appdir}"; \
	$(INSTALL_EXEC) "$(SCRIPT)" "$${bindir}"; \
	$(INSTALL_DATA) "$(PACKAGE).png" "$${pixdir}"; \
	$(INSTALL_EXEC) "$(PACKAGE).desktop" "$${appdir}"; \

uninstall:
	@target=$(DESTDIR)$(prefix); \
	bindir=$${target}/$(BINDIR); \
	appdir=$${target}/$(APPDIR); \
	pixdir=$${target}/$(PIXDIR); \
	$(UNINSTALL) "$${bindir}/$(SCRIPT)" "$${appdir}/$(PACKAGE).desktop" "$${pixdir}/$(PACKAGE).png"; \

dist: distclean $(DISTFILES)
	@mkdir -vp "$(DISTNAME)"; \
	cp -v $(DISTFILES) "$(DISTNAME)"; \
	cp -vR $(DISTDIRS) "$(DISTNAME)"; \
	tar -vcJf "$(DISTPACKAGE)" "$(DISTNAME)"; \
	find "$(DISTNAME)" -type f -delete; \
	find "$(DISTNAME)" -type d -empty -delete; \

distclean: clean debuild-clean
	@if [ -d "$(DISTNAME)" ]; then \
		find "$(DISTNAME)" -type f -delete; \
		find "$(DISTNAME)" -type d -empty -delete; \
	fi; \
	if [ -f "$(DISTPACKAGE)" ]; then \
		rm -vf "$(DISTPACKAGE)"; \
	fi; \

clean:

debianize: dist
	@dh_make -n -c mit -e antumdeluge@gmail.com -f "$(DISTPACKAGE)" -p "$(PACKAGE)_$(VERSION)" -i

debuild:
	@debuild -b -uc -us

debuild-source:
	@debuild -S -uc -us

debuild-signed:
	@debuild -S -sa

debuild-clean:
	@rm -vrf "debian/stendhal-webstart"; \
	rm -vf $(DEBUILD_FILES); \

help:
	@echo "Usage:"; \
	\
	echo "\tmake [command]\n"; \
	\
	echo "Commands:"; \
	\
	echo "\thelp"; \
	echo "\t\t- Show this help dialog\n"; \
	\
	echo "\tinstall"; \
	echo "\t\t- Install stendhal-webstart onto the system\n"; \
	\
	echo "\tuninstall"; \
	echo "\t\t- Remove all installed stendhal-webstart files"; \
	echo "\t\t  from the system\n"; \
	\
	echo "\tdist"; \
	echo "\t\t- Create a source distribution package\n"; \
	\
	echo "\tdebianize"; \
	echo "\t\t- Configure source for building a Debian package"; \
	echo "\t\t  (not necessary, should already be configured)"; \
	echo "\t\t- Uses `tput bold`dh_make`tput sgr0` command (apt install dh-make)\n"; \
	\
	echo "\tdebuild"; \
	echo "\t\t- Build a Debian (.deb) package for installation"; \
	echo "\t\t- Uses `tput bold`debuild`tput sgr0` command (apt install devscripts)\n"; \
	\
	echo "\tdebuild-source"; \
	echo "\t\t- Create a source distribution package with"; \
	echo "\t\t  Debian .dsc, .build, & .changes files\n"; \
	\
	echo "\tdebuild-signed"; \
	echo "\t\t- Create a source distribution package & sign"; \
	echo "\t\t  it for upload to a repository\n"; \
	\
	echo "\tclean"; \
	echo "\t\t- Does nothing\n"; \
	\
	echo "\tdebuild-clean"; \
	echo "\t\t- Delete files create by `tput bold`debuild`tput sgr0`\n"; \
	\
	echo "\tdistclean"; \
	echo "\t\t- Run `tput bold`clean`tput sgr0` & `tput bold`debuild-clean`tput sgr0`\n"; \
	\
	echo "Environment Variables:"; \
	\
	echo "\tprefix"; \
	echo "\t\t- Target prefix under which files will be installed"; \
	echo "\t\t- Default is /usr/local\n"; \
	\
	echo "\tDESTDIR"; \
	echo "\t\t- Prepends a target directory to prefix"; \
	echo "\t\t- Files will be installed under DESTDIR\prefix"; \
	echo "\t\t- If used with `tput bold`uninstall`tput sgr0` it must match that of"; \
	echo "\t\t  the `tput bold`install`tput sgr0` invocation\n"; \
