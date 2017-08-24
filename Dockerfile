# vim:set ft=dockerfile:
FROM debian:jessie

WORKDIR /root

ENV LANG en_US.utf8
ENV TERM dumb
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
rm -f /lib/systemd/system/plymouth*; \
rm -f /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/lib/systemd/systemd"]
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      sudo \
      apt-utils \
      locales \
      expect

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ADD scrolloutf1.tar .

RUN chmod 755 scrolloutf1/www/bin/* && rm -Rf scrolloutf1/www/bin/install.sh
ADD install.sh scrolloutf1/www/bin/install.sh
ADD install scrolloutf1/www/bin/install
RUN bash scrolloutf1/www/bin/install.sh && rm -rf /var/lib/apt/lists/*

EXPOSE 25
EXPOSE 80
EXPOSE 443
EXPOSE 270