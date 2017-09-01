# apache docker container

## Usage

```
docker create \
--name  apache \
-v /etc/localtime:/etc/localtime:ro \
-v <path_to_data>:/config \
-e PUID=<uid> -e PGID=<gid> \
-p 80:80
jeeva420/apache
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 80:80` - the port(s)
* `-v /config` - Data / Log  / Conig directory
* `-v /etc/localtime` for timesync - see [Localtime](#localtime) for important information
* `-e TZ` for timezone information, Europe/London - see [Localtime](#localtime) for important information
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

It is based on Ubuntu with s6 overlay, for shell access whilst the container is running do `docker exec -it apache /bin/bash`.

## Data and config and logs
* The Logs are created under <path_to_data>/log/apache directory
* Copy user site configurations (*.conf) under  <path_to_data>/apache/site-confs directory
* Copy your web contents (Document root) under <path_to_data>/www directory

## Localtime

It is important that you either set `-v /etc/localtime:/etc/localtime:ro` or the TZ variable, Container may throw exceptions without one of them set.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

Access your webserver at  `<your-ip>:80`.