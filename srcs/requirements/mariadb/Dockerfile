FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/script.sh /script.sh

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod +x /script.sh

CMD ["/script.sh"]