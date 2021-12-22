#ifndef CROSS_COMPILE
#$(error ERROR: CROSS_COMPILE is not defined)
#endif
#ifndef TARGETDIR
#$(error ERROR: TARGETDIR is not defined)
#endif

# comment out : johnkim
#CROSS		= $(CROSS_COMPILE)
#CC		= $(CROSS_COMPILE)gcc
#AS		= $(CROSS_COMPILE)as
#CXX		= $(CROSS_COMPILE)g++
#AR		= $(CROSS_COMPILE)ar
#LD		= $(CROSS_COMPILE)ld
#OBJCOPY		= $(CROSS_COMPILE)objcopy
#RANLIB		= $(CROSS_COMPILE)ranlib
#STRIP		= $(CROSS_COMPILE)strip
#NM		= $(CROSS_COMPILE)nm
#INSTALL		= install
#MAKE		= make
#YACC		= bison -y
#LEX		= flex

#all: all-recursive
#all-recursive: pre-all-recursive

#depend: depend-recursive
#depend-recursive: pre-depend-recursive

#install: install-recursive
#install-recursive: pre-install-recursive

#clean: clean-recursive
#clean-recursive: pre-clean-recursive

#pre-all-recursive pre-depend-recursive pre-install-recursive pre-clean-recursive:

#all-recursive depend-recursive install-recursive clean-recursive:
#	@subdirs="$(SUBDIRS)"; \
#	for subdir in $$subdirs; do \
#		if test -d "$$subdir"; then \
#			target=`echo $@ | sed 's/-recursive//'`; \
#				echo "Making $$target in $$subdir"; \
#			$(MAKE) -C "$$subdir" -f xmake $$target || exit 1; \
#		else \
#			echo "The directory '$$subdir' does not exist."; \
#			exit 1; \
#		fi \
#	done
