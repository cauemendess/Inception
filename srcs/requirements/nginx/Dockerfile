FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/nginx/sites-enabled/default && \
    rm /etc/nginx/sites-available/default

COPY ./config/default /etc/nginx/sites-available/inception
RUN ln -s /etc/nginx/sites-available/inception /etc/nginx/sites-enabled/

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

CMD ["/entrypoint.sh"]
