FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY default /etc/nginx/sites-available/.

CMD ["nginx", "-g", "daemon off;"]
