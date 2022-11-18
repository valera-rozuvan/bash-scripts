# cgit server setup

A bunch of shell scripts and config files to make life easier when setting up a cgit server.

## prerequisites

This section is a work in progress.

## setup

To setup a cgit server:

```
./setup-00.sh > ./setup-00.log 2>&1
```

You can watch the logs during the setup:

```
tail -f ./setup-00.log
```

## old info

To setup server:

```
sudo aptitude install --without-recommends \
  ufw \
  fail2ban \
  cgit \
  git \
  nginx \
  fcgiwrap \
  certbot \
  python3 \
  python3-pygments \
  python3-markdown \
  python3-certbot-nginx \
  lighttpd \
  lighttpd-doc \
  pv \
  rsync
```

To make backup of LE certs:

```
sudo tar zpcvf /home/valera/le-bckp-20210613.tar.gz /etc/letsencrypt/
```

To get LE certs from backup:

```
sudo tar zxvf le-bckp-20210613.tar.gz -C /
```

To fetch new certs for new domains:

```
sudo certbot --nginx -d git.rozuvan.net --post-hook "/usr/sbin/service nginx restart"
sudo certbot --nginx -d test.rozuvan.net --post-hook "/usr/sbin/service nginx restart"
...
```

To renew certs:

```
sudo certbot renew
```

That's it!
