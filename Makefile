PREFIX=/usr/local
INSTALL_DIR=$(PREFIX)/bin
DIFFTANCE_SYSTEM_BIN=$(INSTALL_DIR)/difftance

OUT_DIR=$(CURDIR)/bin
DIFFTANCE_BIN=$(OUT_DIR)/difftance

DIFFTANCE_SOURCES=$(shell find src/ -type f -name '*.cr')

$(INSTALL_DIR):
	mkdir -p $@

build: $(DIFFTANCE_BIN)

$(DIFFTANCE_BIN): $(DIFFTANCE_SOURCES)
	shards build --release --no-debug

build-static: $(DIFFTANCE_SOURCES)
	shards build --release --no-debug --static

install: build | $(INSTALL_DIR)
	cp $(DIFFTANCE_BIN) $(DIFFTANCE_SYSTEM_BIN)
