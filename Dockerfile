FROM bitnami/minideb:latest

ARG USER=default
ENV HOME /home/$USER
ENV THEOS=$HOME/theos

RUN apt update && apt install bash curl sudo build-essential fakeroot libtinfo5 libz3-dev rsync perl unzip git libplist-utils wget p7zip-full -y
RUN curl -s https://swiftlang.xyz/install.sh | bash && apt install swiftlang -y

RUN adduser --disabled-password --gecos "" $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN git clone https://github.com/theos/theos.git $THEOS --recursive

RUN TMP_DL=$(mktemp -d) \
	&& wget --no-verbose https://github.com/kabiroberai/swift-toolchain-linux/releases/download/v2.3.0/swift-5.8-ubuntu22.04.tar.xz -P $TMP_DL \
	&& tar -xvf $TMP_DL/swift-5.8-ubuntu22.04.tar.xz -C $THEOS/toolchain \
	&& rm -Rf $TMP_DL

RUN cd $THEOS/sdks \
	&& wget --no-verbose https://github.com/theos/sdks/archive/master.zip \
	&& TMP=$(mktemp -d) \
	&& 7z x master.zip -o$TMP \
	&& mv $TMP/*-master/*.sdk $THEOS/sdks \
	&& rm -r master.zip $TMP

RUN cd $THEOS \
	&& git fetch \
	&& git checkout orion \
	&& git submodule update --init

RUN $THEOS/bin/swift-bootstrapper.pl swift $THEOS/vendor/orion

USER root
RUN chown -R $USER:$USER $HOME/theos
