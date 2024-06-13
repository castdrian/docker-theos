FROM bitnami/minideb:latest

ARG USER=default
ENV HOME /home/$USER
ENV THEOS=$HOME/theos

RUN apt update && apt install bash curl libarchive-tools sudo wget -y
RUN curl -s https://swiftlang.xyz/install.sh | bash && apt install swiftlang -y

RUN adduser --disabled-password --gecos "" $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN yes | bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"

RUN TMP_DL=$(mktemp -d) \
	&& wget --no-verbose https://github.com/kabiroberai/swift-toolchain-linux/releases/download/v2.3.0/swift-5.8-ubuntu22.04.tar.xz -P $TMP_DL \
	&& tar -xvf $TMP_DL/swift-5.8-ubuntu22.04.tar.xz -C $THEOS/toolchain \
	&& rm -Rf $TMP_DL

RUN $THEOS/bin/swift-bootstrapper.pl swift $THEOS/vendor/orion

USER root
RUN chown -R $USER:$USER $THEOS
