# aliyun-ddns

## Summary
ddns for aliyun with bash shell.

there is a script file, you could run it directly.
or use the provided docker container.

## Run directly
1. install the aliyuncli sdk yourself
2. configure the access_key_id and access_key_secret
3. uncomment the follow code at the top of the script file "ddns"
```bash
#RR=test
#DOMAIN=yourdomain.com
#INTERVAL=3
```
4. maybe you should give x permission to the script, like
```bash
chmod +x ddns
```
5. execute the script file in any way you want

## Install with Docker
1. pull the docker image
```bash
docker pull chenluo/aliyun-ddns
```

2. you can direct deploy the container with "docker run"
```bash
docker run \
    -it -d --restart=always \
    -v /your_log_file_path:/var/log/ddns.log \
    --env KEY_ID=your_access_key_id \
    --env KEY_SECRET=your_access_key_secret \
    --env RR=your_resource_record \
    --env DOMAIN=your_domain \
    --env INTERVAL=3 \
    --name ddns \
    chenluo/aliyun-ddns
```

3. you can also deploy with the docker-compose, this is docker-compose.yml below
```yaml
version: '3'
services:
  ddns:
    image: chenluo/aliyun-ddns
    container_name: ddns
    restart: always
    environment:
      - KEY_ID=your_access_key_id
      - KEY_SECRET=your_access_key_secret
      - RR=your_resource_record
      - DOMAIN=your_domain
      - INTERVAL=3
    volumes:
      - /your_log_file_path:/var/log/ddns.log
    tty: true
```
