FROM bitnami/minideb:latest

ARG USER=default
ENV HOME /home/$USER

RUN apt update && apt install sudo curl bash 
RUN apt install swiftlang=5.10*

RUN adduser --disabled-password --gecos "" $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN echo y | bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
