FROM alpine:3.12

ENV KEY_ID="" \
    KEY_SECRET="" \
    RR="" \
    DOMAIN="" \
    INTERVAL=3

# set apk source to tsinghua university and install required commands and tools
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        jq \
        curl \
    && rm -rf /var/cache/apk/*

# install aliyuncli
RUN wget https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.40-amd64.tgz \
    && tar -xvzf aliyun-cli-linux-3.0.40-amd64.tgz \
    && rm aliyun-cli-linux-3.0.40-amd64.tgz \
    && mv aliyun /usr/local/bin/

# install ddns program and add a crontab task
COPY ddns /usr/local/bin/
RUN chmod +x /usr/local/bin/ddns

CMD aliyun configure set \
    --profile akProfile \
    --mode AK \
    --region cn-hangzhou \
    --access-key-id ${KEY_ID} \
    --access-key-secret ${KEY_SECRET} \
    && echo "*/${INTERVAL} * * * * /usr/local/bin/ddns >> /log/ddns.log 2>&1">>/var/spool/cron/crontabs/root \
    && crond \
    && /bin/sh
