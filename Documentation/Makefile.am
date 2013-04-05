docdir = $(prefix)/share/t4-$(T4_VERSION)
doc_DATA = t4.xml

m4_files = ../t4.m4

t4.xml: $(m4_files)
	./mkxml.sh t4.xml $(m4_files)

EXTRA_DIST = mkxml.sh
