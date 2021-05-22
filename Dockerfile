FROM alpine:latest

ENV SPUG_VERSION 2.3.16


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache nginx git openldap-dev supervisor redis bash

RUN apk add --no-cache --virtual .build-deps build-base openssl-dev gcc musl-dev python3-dev libffi-dev openssh-client make

# pyhon api
# wget https://github.com/openspug/spug/archive/v2.3.16.tar.gz 
RUN mkdir /spug && cd /spug \
    && wget https://github.com/openspug/spug/archive/v${SPUG_VERSION}.tar.gz \
    && tar zxf v${SPUG_VERSION}.tar.gz -C /spug --strip-components 1 && rm -rf tar zxf v${SPUG_VERSION}.tar.gz \
    && cd /spug/spug_api && python3 -m venv venv && source venv/bin/activate \
    && pip install --upgrade pip && export CRYPTOGRAPHY_DONT_BUILD_RUST=1 \ 
    && pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip install --no-cache-dir gunicorn -i https://mirrors.aliyun.com/pypi/simple/

# web
# https://github.com/openspug/spug/releases/download/v${SPUG_VERSION}/web_v${SPUG_VERSION}.tar.gz
RUN cd /spug && wget https://github.com/openspug/spug/releases/download/v${SPUG_VERSION}/web_v${SPUG_VERSION}.tar.gz \
    && tar zxf web_v${SPUG_VERSION}.tar.gz -C /spug/spug_web/ && rm -rf web_v${SPUG_VERSION}.tar.gz

RUN mkdir -p  /spug/spug_api/db

ADD overrides.py /spug/spug_api/spug/overrides.py
ADD spug.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /etc/supervisor.d
ADD spug.ini /etc/supervisor.d/spug.ini
ADD entrypoint.sh /entrypoint.sh

EXPOSE 80

CMD ["sh", "/entrypoint.sh"]
