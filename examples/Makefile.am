noinst_SCRIPTS = 			\
	hello-world			\
	demo				\
	$(NULL)

CLEANFILES = $(noinst_SCRIPTS)

%: %.t4
	t4c $< $@
