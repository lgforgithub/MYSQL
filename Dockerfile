FROM ubuntu
MAINTAINER lg 
RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN apt-get update && apt-get install -y perl --no-install-recommends && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
RUN wget -P / https://raw.githubusercontent.com/lgforgithub/MYSQL/master/entrypoint.sh && chmod +x entrypoint.sh
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6
RUN echo "deb http://repo.mysql.com/apt/debian/ wheezy mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list
RUN apt-get update && apt-get install dialog && (echo mysql-community-server mysql-community-server/data-dir select '';echo mysql-community-server mysql-community-server/root-pass password ''; echo mysql-community-server mysql-community-server/re-root-pass password ''; echo mysql-community-server mysql-community-server/remove-test-db select false; ) | debconf-set-selections    &&  apt-get install -y mysql-server="${MYSQL_VERSION}"* && rm -rf /var/lib/apt/lists/*    && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf    
VOLUME [/var/lib/mysql] 
ENTRYPOINT ["/entrypoint.sh"] 
EXPOSE 3306/tcp
CMD ["mysqld"]