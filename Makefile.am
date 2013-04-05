SUBDIRS = Documentation

bin_SCRIPTS = t4c

t4dir = $(prefix)/share/t4-$(T4_VERSION)
t4_DATA = t4.m4

examples:
	$(MAKE) -C examples

t4c: t4c.sh
	cp $< $@
	chmod +x $@

EXTRA_DIST = 				\
	AUTHORS				\
	INSTALL				\
	LICENSE				\
	README.in			\
	$(NULL)
