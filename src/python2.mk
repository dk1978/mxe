# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python2
$(PKG)_WEBSITE  := https://github.com/dk1978/cpython
$(PKG)_DESCR    := Python 2.7.15 with patches for cross-compilation
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 
$(PKG)_CHECKSUM := 1e2ceb0b97a1670cc76533589a927479fa1ab562bdcc9ba1beca5e8bafae69db
$(PKG)_GH_CONF  := dk1978/cpython/tags, 2.7_mingw
$(PKG)_DEPS     := cc expat libffi
#$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
#$(PKG)_TYPE     := source-only

define $(PKG)_BUILD
# Use the native gcc compiler to build a bootstrap python executable
# --disable-shared to reduce compilation time and hidden dependencies on the build system
    mkdir -p '$(BUILD_DIR)/native_build' && cd '$(BUILD_DIR)/native_build' && \
      TARGET=x86_64-pc-linux-gnu \
      BUILD=x86_64-pc-linux-gnu \
      $(SOURCE_DIR)/configure \
        --disable-shared \
        --disable-ipv6
    $(MAKE) -C $(BUILD_DIR)/native_build -j '$(JOBS)'

# Now use the MXE cross-compiler and the bootstrap python executable
    cd '$(BUILD_DIR)' && \
        ac_cv_file__dev_ptmx=no \
        ac_cv_file__dev_ptc=no \
        $(SOURCE_DIR)/configure \
             $(MXE_CONFIGURE_OPTS) \
             $(if $(BUILD_STATIC), \
                  --enable-static --disable-shared , \
                  --disable-static --enable-shared ) \
            --with-pydebug \
            --with-libs='-lversion -lshlwapi -lwsock32' \
            --enable-shared \
	    --with-system-expat \
	    --with-system-ffi \
            --without-ensurepip \
            CROSSCOMPILING_PYTHON_FOR_BUILD=$(BUILD_DIR)/native_build/python \
            CPPFLAGS='-D_WIN32_WINNT=_WIN32_WINNT_WIN7'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 libinstall inclinstall libainstall sharedinstall bininstall
endef
