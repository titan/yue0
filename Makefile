NAME = yue0
include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
TARGET = $(BUILDDIR)/yue0

CORESRC:=$(BUILDDIR)/yue0.py
PARSERSRC:=$(BUILDDIR)/parser.py $(BUILDDIR)/yast.py
LEXFSMSRC:=$(BUILDDIR)/lex_fsm.py
SYNTAXFSMSRC:=$(BUILDDIR)/syntax_fsm.py

DEPENDS = $(CORESRC) $(PARSERSRC) $(LEXFSMSRC) $(SYNTAXFSMSRC)

all: $(TARGET)

$(TARGET): $(DEPENDS)
	cp $(BUILDDIR)/yue0.py $@
	chmod 755 $@

$(CORESRC): core.org | prebuild
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(PARSERSRC): parser.org | prebuild
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(LEXFSMSRC): lex-fsm.txt | prebuild
	fsm-generator.py $< -d $(BUILDDIR) --prefix lex --style table --target python

$(SYNTAXFSMSRC): syntax-fsm.txt | prebuild
	fsm-generator.py $< -d $(BUILDDIR) --prefix lex --style table --target python

prebuild:
ifeq "$(wildcard $(BUILDDIR))" ""
	mkdir -p $(BUILDDIR)
endif

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean prebuild
