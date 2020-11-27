FROM nginx:1.19.5-alpine
LABEL maintainer="me@muyiafan.com"
ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
