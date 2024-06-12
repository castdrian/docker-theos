FROM bitnami/minideb:latest

ARG USER=default
ENV HOME /home/$USER

RUN apt update && apt install sudo curl bash -y
RUN curl -s https://swiftlang.xyz/install.sh | bash && apt install swiftlang -y

RUN adduser --disabled-password --gecos "" $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN yes | bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
