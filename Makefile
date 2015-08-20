PREFIX ?= /usr/local
BINPREFIX ?= "$(PREFIX)/bin"
MANPREFIX ?= "$(PREFIX)/share/man/man1"
BINS = $(wildcard bin/git-*)
MANS = $(wildcard man/git-*.md)
MAN_HTML = $(MANS:.md=.html)
MAN_PAGES = $(MANS:.md=.1)
LIB = "helper/reset-env" "helper/git-extra-utility"

COMMANDS_USED_WITHOUT_GIT_REPO = git-alias git-extras git-fork git-setup
COMMANDS_USED_WITH_GIT_REPO = $(filter-out $(COMMANDS_USED_WITHOUT_GIT_REPO), \
							  $(subst bin/, , $(BINS)))

default: install

docs: $(MAN_HTML) $(MAN_PAGES)

install:
	@mkdir -p $(DESTDIR)$(MANPREFIX)
	@mkdir -p $(DESTDIR)$(BINPREFIX)
	@echo "... installing bins to $(DESTDIR)$(BINPREFIX)"
	@echo "... installing man pages to $(DESTDIR)$(MANPREFIX)"
	$(eval TEMPFILE := $(shell mktemp -q ${TMPDIR:-/tmp}/git-extras.XXXXXX 2>/dev/null || mktemp -q))
	@# chmod from rw-------(default) to rwxrwxr-x, so that users can exec the scripts
	@chmod 775 $(TEMPFILE)
	@$(foreach COMMAND, $(COMMANDS_USED_WITH_GIT_REPO), \
		echo "... installing $(COMMAND)"; \
		head -1 bin/$(COMMAND) | cat - $(LIB) ./helper/is-git-repo > $(TEMPFILE); \
		tail -n +2 bin/$(COMMAND) >> $(TEMPFILE); \
		cp -f $(TEMPFILE) $(DESTDIR)$(BINPREFIX)/$(COMMAND); \
	)
	@$(foreach COMMAND, $(COMMANDS_USED_WITHOUT_GIT_REPO), \
		echo "... installing $(COMMAND)"; \
		head -1 bin/$(COMMAND) | cat - $(LIB) > $(TEMPFILE); \
		tail -n +2 bin/$(COMMAND) >> $(TEMPFILE); \
		cp -f $(TEMPFILE) $(DESTDIR)$(BINPREFIX)/$(COMMAND); \
	)
	@if [ -z "$(wildcard man/git-*.1)" ]; then \
		echo "WARNING: man pages not created, use 'make docs' (which requires 'ronn' ruby lib)"; \
	else \
		cp -f man/git-*.1 $(DESTDIR)$(MANPREFIX); \
		echo "cp -f man/git-*.1 $(DESTDIR)$(MANPREFIX)"; \
	fi
	@mkdir -p $(DESTDIR)/etc/bash_completion.d
	cp -f etc/bash_completion.sh $(DESTDIR)/etc/bash_completion.d/git-extras

man/%.html: man/%.md
	ronn \
		--manual "Git Extras" \
		--html \
		--pipe \
		$< > $@

man/%.1: man/%.md
	ronn -r \
		--manual "Git Extras" \
		--pipe \
		$< > $@

uninstall:
	@$(foreach BIN, $(BINS), \
		echo "... uninstalling $(DESTDIR)$(BINPREFIX)/$(notdir $(BIN))"; \
		rm -f $(DESTDIR)$(BINPREFIX)/$(notdir $(BIN)); \
	)
	@$(foreach MAN, $(MAN_PAGES), \
		echo "... uninstalling $(DESTDIR)$(MANPREFIX)/$(notdir $(MAN))"; \
		rm -f $(DESTDIR)$(MANPREFIX)/$(notdir $(MAN)); \
	)
	rm -f $(DESTDIR)/etc/bash_completion.d/git-extras

clean: docclean

docclean:
	rm -f man/*.1
	rm -f man/*.html

.PHONY: default docs clean docclean install uninstall
