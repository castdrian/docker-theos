FROM bitnami/minideb:latest

RUN apt update && apt install build-essential fakeroot libtinfo5 libz3-dev rsync curl wget perl unzip git sudo libplist-utils p7zip-full libncurses6 -y
RUN git clone https://github.com/theos/theos --recursive

ENV THEOS=/theos

RUN TMP_DL=$(mktemp -d) && \
	wget --no-verbose https://github.com/kabiroberai/swift-toolchain-linux/releases/download/v2.3.0/swift-5.8-ubuntu22.04.tar.xz -P $TMP_DL && \
	tar -xvf $TMP_DL/swift-5.8-ubuntu22.04.tar.xz -C $THEOS/toolchain && \
	rm -Rf $TMP_DL

RUN cd $THEOS/sdks && \
	wget --no-verbose https://github.com/theos/sdks/archive/master.zip && \
	TMP=$(mktemp -d) && \
	7z x master.zip -o$TMP && \
	mv $TMP/*-master/*.sdk $THEOS/sdks && \
	rm -r master.zip $TMP

RUN cd $THEOS && \
	git fetch && \
	git checkout orion && \
	git submodule update --init

RUN printf "18\nsetup\n\n\n\n\n" | $THEOS/bin/nic.pl
RUN cd setup && make
RUN rm -rf setup