###########################################################

ifeq (,$(PLATFORM))
PLATFORM=$(UNION_PLATFORM)
endif

ifeq (,$(PLATFORM))
$(error please specify PLATFORM, eg. PLATFORM=trimui make)
endif

###########################################################

all: readmes

early:
	@if [ ! -f $(PREFIX)/lib/liblz4.so ]; then \
		echo "Building lz4 for $(PLATFORM)..."; \
		chmod +x support/build-lz4.sh && ./support/build-lz4.sh; \
	fi
	@if [ ! -f $(PREFIX)/lib/libsamplerate.so ]; then \
		echo "Building libsamplerate for $(PLATFORM)..."; \
		chmod +x support/build-libsamplerate.sh && ./support/build-libsamplerate.sh; \
	fi

clean:
	
include ../all/readmes/makefile