FROM alpine:latest

RUN apk update \
	&& apk add curl bash \
	&&  bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
