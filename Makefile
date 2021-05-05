# libressl package
package := $(LIBRESSL_PACKAGE_NAME)
packagedir := $(LIBRESSL_PACKAGE_DIR)

# x86_64
builddir-x86_64 := $(CONFIGURATION_TEMP_DIR)/$(package)-x86_64.build
installdir-x86_64 := $(CONFIGURATION_TEMP_DIR)/$(package)-x86_64.install
libdir-x86_64 := $(installdir-x86_64)/lib
includedir-x86_64 := $(installdir-x86_64)/include

# arm64
builddir-arm64 := $(CONFIGURATION_TEMP_DIR)/$(package)-arm64.build
installdir-arm64 := $(CONFIGURATION_TEMP_DIR)/$(package)-arm64.install
libdir-arm64 := $(installdir-arm64)/lib
includedir-arm64 := $(installdir-arm64)/include

# universal
installdir := $(CONFIGURATION_TEMP_DIR)/$(package).install
bindir := $(installdir)/bin
includedir := $(installdir)/include
libdir := $(installdir)/lib

openssldir := $(shell /usr/bin/openssl version -d | awk -F'"' '{ print $$2 }')
build-arch := $(shell /usr/bin/uname -m)

CC := $(shell xcrun --sdk macosx --find cc)
LIPO := $(shell xcrun --sdk macosx --find lipo)
INSTALL_NAME_TOOL := $(shell xcrun --sdk macosx --find install_name_tool)
SDKROOT := $(shell xcrun --sdk macosx --show-sdk-path)

ifeq ($(ONLY_ACTIVE_ARCH),YES)
target-archs := $(build-arch)
else
target-archs := $(ARCHS)
endif

# bin
bindir-archs := $(foreach dir,$(addprefix installdir-,$(target-archs)),$($(dir))/bin)
bindir-arch := $(firstword $(bindir-archs))

ocspcheck-name := ocspcheck
ocspcheck-archs := $(addsuffix /$(ocspcheck-name),$(bindir-archs))

openssl-name := openssl
openssl-archs := $(addsuffix /$(openssl-name),$(bindir-archs))

# lib
libdir-archs := $(foreach dir,$(addprefix installdir-,$(target-archs)),$($(dir))/lib)
libdir-arch := $(firstword $(libdir-archs))

libcrypto-linkname := libcrypto.dylib
libcrypto-archs := $(addsuffix /$(libcrypto-linkname),$(libdir-archs))
libcrypto-name = $(shell readlink -n $(firstword $(libcrypto-archs)))

libssl-linkname := libssl.dylib
libssl-archs := $(addsuffix /$(libssl-linkname),$(libdir-archs))
libssl-name = $(shell readlink -n $(firstword $(libssl-archs)))

libtls-linkname := libtls.dylib
libtls-archs := $(addsuffix /$(libtls-linkname),$(libdir-archs))
libtls-name = $(shell readlink -n $(firstword $(libtls-archs)))

# include
includedir-archs := $(foreach dir,$(addprefix installdir-,$(target-archs)),$($(dir))/include)
includedir-arch := $(firstword $(includedir-archs))

# share
sharedir-archs := $(foreach dir,$(addprefix installdir-,$(target-archs)),$($(dir))/share)
sharedir-arch := $(firstword $(sharedir-archs))

# configure
CONFIGURE := $(packagedir)/configure

# CFLAGS
CFLAGS := -Wno-unguarded-availability-new $(CFLAGS)

# DEBUG_CFLAGS
DEBUG_CFLAGS :=
ifeq ($(GCC_GENERATE_DEBUGGING_SYMBOLS),YES)
DEBUG_CFLAGS += -g
endif
ifdef GCC_OPTIMIZATION_LEVEL
DEBUG_CFLAGS += -O$(GCC_OPTIMIZATION_LEVEL)
endif
ifdef GCC_PREPROCESSOR_DEFINITIONS
DEBUG_CFLAGS += $(addprefix -D,$(GCC_PREPROCESSOR_DEFINITIONS))
endif

# x86_64
CFLAGS_x86_64 := \
	-arch x86_64 \
	-isysroot $(SDKROOT) \
	--target=x86_64-$(LLVM_TARGET_TRIPLE_VENDOR)-$(LLVM_TARGET_TRIPLE_OS_VERSION)
LDFLAGS_x86_64 := $(CFLAGS_x86_64) $(LDFLAGS) $(OTHER_LDFLAGS)
CONFIGUREFLAGS_x86_64 := \
	--prefix="$(installdir-x86_64)" \
	--libdir="$(libdir-x86_64)" \
	--includedir="$(includedir-x86_64)" \
	--host=x86_64-apple-darwin \
	--disable-asm \
	--with-openssldir="$(openssldir)" $(CONFIGUREFLAGS)
# arm64
CFLAGS_arm64 := \
	-arch arm64 \
	-isysroot $(SDKROOT) \
	--target=arm64-$(LLVM_TARGET_TRIPLE_VENDOR)-$(LLVM_TARGET_TRIPLE_OS_VERSION)
LDFLAGS_arm64 := $(CFLAGS_arm64) $(LDFLAGS) $(OTHER_LDFLAGS)
CONFIGUREFLAGS_arm64 := \
	--prefix="$(installdir-arm64)" \
	--libdir="$(libdir-arm64)" \
	--includedir="$(includedir-arm64)" \
	--host=aarch64-apple-darwin \
	--disable-asm \
	--with-openssldir="$(openssldir)" $(CONFIGUREFLAGS)

all: install

clean: $(addprefix clean-,$(target-archs))
	-rm -rf $(installdir)

install: $(addprefix install-,$(target-archs))
	install -d $(installdir)
    # bin
	install -d $(bindir)
	cd $(bindir) && \
	$(LIPO) $(ocspcheck-archs) -create -output $(ocspcheck-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libcrypto-name) $(libdir)/$(libcrypto-name) $(ocspcheck-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libssl-name) $(libdir)/$(libssl-name) $(ocspcheck-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libtls-name) $(libdir)/$(libtls-name) $(ocspcheck-name) && \
	$(LIPO) $(openssl-archs) -create -output $(openssl-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libcrypto-name) $(libdir)/$(libcrypto-name) $(openssl-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libssl-name) $(libdir)/$(libssl-name) $(openssl-name)
    # include
	cp -a $(includedir-arch) $(installdir)
    # lib
	install -d $(libdir) && \
	cd $(libdir) && \
	$(LIPO) $(libcrypto-archs) -create -output $(libcrypto-name) && \
	ln -fns $(libcrypto-name) $(libcrypto-linkname) && \
	$(INSTALL_NAME_TOOL) -id $(libdir)/$(libcrypto-name) $(libcrypto-name) && \
	$(LIPO) $(libssl-archs) -create -output $(libssl-name) && \
	ln -fns $(libssl-name) $(libssl-linkname) && \
	$(INSTALL_NAME_TOOL) -id $(libdir)/$(libssl-name) $(libssl-name) && \
	$(INSTALL_NAME_TOOL) -change $(libdir-arch)/$(libcrypto-name) $(libdir)/$(libcrypto-name) $(libssl-name) && \
	$(LIPO) $(libtls-archs) -create -output $(libtls-name) && \
	ln -fns $(libtls-name) $(libtls-linkname) && \
	$(INSTALL_NAME_TOOL) -id $(libdir)/$(libtls-name) $(libtls-name)
    # share
	cp -a $(sharedir-arch) $(installdir)

test: $(addprefix test-,$(target-archs))

libressl: $(addprefix libressl-,$(target-archs))

builddir-% installdir-%:
	-mkdir -p $($@)

$(addprefix clean-,$(target-archs)): clean-%:
	-rm -rf $(installdir-$*) && \
	cd $(builddir-$*) && \
	make distclean || true

$(addprefix install-,$(target-archs)): install-%: clean-% test-% installdir-%
	cd $(builddir-$*) && \
	make install

$(addprefix test-,$(target-archs)): test-%: libressl-%
	$(if $(filter $(build-arch),$*),cd $(builddir-$*) && make check)

$(addprefix libressl-,$(target-archs)): libressl-%: builddir-%
	cd $(builddir-$*) && \
	find . \( \
		-name aclocal.m4 -or \
		-name configure -or \
		-name Makefile.am -or \
		-name Makefile.in \) \
	-print0 | xargs -0 touch -t "`date +%y%m%d%H%M.%S`" && \
	CC="$(CC)" CFLAGS="$(CFLAGS_$*) $(CFLAGS) $(OTHER_CFLAGS) $(DEBUG_CFLAGS)" LDFLAGS="$(LDFLAGS_$*)" $(CONFIGURE) $(CONFIGUREFLAGS_$*) && \
	make

.PHONY: all clean install test libressl
