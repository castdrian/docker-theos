FROM bitnami/minideb:latest

ARG USER=default
ENV HOME /home/$USER

RUN apt-get update && apt-get install sudo curl bash

RUN adduser -D $USER \
	&& echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
	&& chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
