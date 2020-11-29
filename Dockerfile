FROM alpine:3.12 as builder

LABEL maintainer="me@muyiafan.com"

RUN apk add --no-cache \
      gcc \
      libc-dev \
      make \
      openssl-dev \
      pcre-dev \
      zlib-dev \
      linux-headers \
      libxslt-dev \
      gd-dev \
      geoip-dev \
      perl-dev \
      libedit-dev \
      mercurial \
      bash \
      alpine-sdk \
      findutils \
      git
RUN mkdir /build && cd /build && wget http://nginx.org/download/nginx-1.19.5.tar.gz \
      && tar -xvf nginx-1.19.5.tar.gz \
      && git clone https://github.com/openresty/headers-more-nginx-module.git \
      && cd nginx-1.19.5 \
      && ./configure --with-compat --add-dynamic-module=/build/headers-more-nginx-module \
      && make modules

FROM nginx:1.19.5-alpine

ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone