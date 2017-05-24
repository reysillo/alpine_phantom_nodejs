FROM alpine:edge

RUN echo $'http://alpine.gliderlabs.com/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk upgrade --update-cache --available && \
    apk add nodejs \
        nodejs-npm \
        xpdf \
        vips \
        vips-dev \
        python2 \
        git \
        make \
        fftw-dev \
        g++ \
        curl

ADD . /app

RUN npm install sharp
# Allow us to get the private npm credentials during the build step
# ARG NPMTOKEN

# Sharp is installed via package.json here
# Private npm credentials are then always removed. The npm creds are never able to be cached so security++

# RUN addgroup "unprivuser" && \
#     adduser -S -u 1000 -h /home/unprivuser -s /bin/sh "unprivuser" && \
#     chown -R unprivuser:unprivuser /app && \
#     echo -e "//registry.npmjs.org/:_authToken=$(echo ${NPMTOKEN})\nprogress=false" > ~/.npmrc && \
#     npm install sharp && \
#     rm -f ~/.npmrc

# Simple test that shows that sharp is installed and produces output
RUN echo -e '"use strict";\nconst sharp = require( "sharp" );\nconsole.log( sharp );' > /app/sharp_test.js && \
    node /app/sharp_test.js && \
    rm -f /app/sharp_test.js

# RUN apk update --no-cache && apk add --no-cache build-base git autoconf automake libtool gettext openssl-dev && \
#     git clone -b master https://github.com/Netflix/dynomite.git && \
#     cd dynomite && \
#     autoreconf -fvi && \
#     ./configure 

# RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
# 	&& apk --update add curl
# RUN apk add --update nodejs nodejs-npm git curl python && npm install npm@latest -g
# RUN apk add g++  make  fftw fftw-dev
# RUN npm install pm2


ENV PHANTOMJS_ARCHIVE="phantomjs.tar.gz"
# RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
# 	&& apk --update add curl


RUN curl -Lk -o $PHANTOMJS_ARCHIVE https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz \
	&& tar -xf $PHANTOMJS_ARCHIVE -C /tmp/ \
	&& cp -R /tmp/etc/fonts /etc/ \
	&& cp -R /tmp/lib/* /lib/ \
	&& cp -R /tmp/lib64 / \
	&& cp -R /tmp/usr/lib/* /usr/lib/ \
	&& cp -R /tmp/usr/lib/x86_64-linux-gnu /usr/ \
	&& cp -R /tmp/usr/share/* /usr/share/ \
	&& cp /tmp/usr/local/bin/phantomjs /usr/bin/ \
	&& rm -fr $PHANTOMJS_ARCHIVE  /tmp/* \
	&& ln -s /usr/bin/phantomjs /usr/local/bin/phantomjs


# RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
# 	&& apk --update add curl
# RUN apk add --update nodejs  git curl python  gcc  g++ make
# nodejs-npm && npm install npm@latest -g

WORKDIR /opt/app
CMD [ "npm", "start" ]
