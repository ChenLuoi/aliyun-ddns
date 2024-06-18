FROM alpine:3.20 as prepare

RUN cd /tmp \
    && wget https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.40-amd64.tgz \
    && tar -xvzf aliyun-cli-linux-3.0.40-amd64.tgz

FROM alpine:3.20

COPY --from=prepare /tmp/aliyun /usr/local/bin/

ENV KEY_ID="" \
    KEY_SECRET="" \
    RR="" \
    DOMAIN="" \
    INTERVAL=3

# set apk source to tsinghua university and install required commands and tools
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
        jq \
        curl \
    && rm -rf /var/cache/apk/*

# install ddns program and add a crontab task
COPY ddns /usr/local/bin/
RUN chmod +x /usr/local/bin/ddns

CMD aliyun configure set \
    --profile akProfile \
    --mode AK \
    --region cn-hangzhou \
    --access-key-id ${KEY_ID} \
    --access-key-secret ${KEY_SECRET} \
    && echo "*/${INTERVAL} * * * * /usr/local/bin/ddns >> /var/log/ddns.log 2>&1" > /var/spool/cron/crontabs/root \
    && crond \
    && /bin/sh
