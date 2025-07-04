FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Gerar certificado SSL auto-assinado
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=42SP/CN=localhost"

COPY default /etc/nginx/sites-available/.

CMD ["nginx", "-g", "daemon off;"]
