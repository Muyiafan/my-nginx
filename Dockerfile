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
      && git clone https://github.com/google/ngx_brotli.git \
      && cd ngx_brotli && git submodule update --init && cd .. \
      && cd nginx-1.19.5 \
      && ./configure --with-compat \
            --add-dynamic-module=/build/headers-more-nginx-module \
            --add-dynamic-module=/build/ngx_brotli \
      && make modules

FROM nginx:1.19.5-alpine

LABEL maintainer="me@muyiafan.com"

ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
COPY --from=builder /build/nginx-1.19.5/objs/ngx_http_headers_more_filter_module.so /etc/nginx/modules
COPY --from=builder /build/nginx-1.19.5/objs/ngx_http_brotli_filter_module.so /etc/nginx/modules
COPY --from=builder /build/nginx-1.19.5/objs/ngx_http_brotli_static_module.so /etc/nginx/modules