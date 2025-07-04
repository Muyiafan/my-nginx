FROM debian:bookworm as builder
LABEL maintainer="me@muyiafan.com"

ENV NGINX_VERSION 1.28.0

RUN apt update \
    && apt install -y libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev wget git gcc make libbrotli-dev

RUN mkdir /build \
      && cd /build && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
      && tar -xvf nginx-${NGINX_VERSION}.tar.gz \
      && git clone --recurse-submodules https://github.com/openresty/headers-more-nginx-module.git \
      && git clone --recurse-submodules https://github.com/google/ngx_brotli.git \
      && cd nginx-${NGINX_VERSION} \
      && ./configure --with-compat \
            --add-dynamic-module=/build/headers-more-nginx-module \
            --add-dynamic-module=/build/ngx_brotli \
      && make modules

FROM nginx:1.28.0-bookworm

LABEL maintainer="me@muyiafan.com"

ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
COPY --from=builder /build/nginx-${NGINX_VERSION}/objs/ngx_http_headers_more_filter_module.so /etc/nginx/modules
COPY --from=builder /build/nginx-${NGINX_VERSION}/objs/ngx_http_brotli_filter_module.so /etc/nginx/modules
COPY --from=builder /build/nginx-${NGINX_VERSION}/objs/ngx_http_brotli_static_module.so /etc/nginx/modules