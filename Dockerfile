FROM alpine:3.3

RUN apk update
RUN apk add docker
RUN apk add openrc
RUN rc-update add docker boot

ADD crontab.txt /crontab.txt
COPY script.sh /script.sh
COPY entry.sh /entry.sh
RUN chmod 755 /script.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]