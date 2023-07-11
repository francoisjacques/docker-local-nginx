# syntax=docker/dockerfile:1.4
FROM nginx:mainline-alpine-slim

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

# Add a /certs volume
VOLUME ["/certs"]

WORKDIR /certs

# Generate a self-signed certificate
# This is strictly to have a default certificate that the container can use as fallback certificate
RUN touch /certs/localhost.pem || \
  mkdir -r /certs && \
  openssl req \ 
    -verbose \
    -x509 -newkey rsa:4096 -nodes \
    -keyout localhost-key.pem \
    -subj "/C=CA/ST=QC/O=My Awesome Company, Inc./CN=myawesomecompany.com" \
    -addext "subjectAltName=DNS:localhost." \
    -out localhost.pem \
    -days 365 \
  && \
  openssl x509 -noout -text -in /certs/localhost.pem

COPY localhost.template /etc/nginx/conf.d/localhost.template
RUN mkdir -p /usr/local/nginx && ln -s /certs /usr/local/nginx/conf
RUN cat <<EOF >> /usr/local/bin/startup.sh
#!/usr/bin/env sh

# failfast
set -e

# trace execution - uncomment to debug
# set -x
envsubst '\$TARGET_SERVER' < /etc/nginx/conf.d/localhost.template > /etc/nginx/conf.d/default.conf
cat /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
exec nginx -s reload
EOF
RUN chmod u+x /usr/local/bin/startup.sh

EXPOSE 80
EXPOSE 443

CMD /usr/local/bin/startup.sh
# syntax=docker/dockerfile:1.4
FROM nginx:mainline-alpine-slim

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

# Add a /certs volume
VOLUME ["/certs"]

WORKDIR /certs

# Generate a self-signed certificate
# This is strictly to have a default certificate that the container can use as fallback certificate
RUN touch /certs/localhost.pem || \
  mkdir -r /certs && \
  openssl req \ 
    -verbose \
    -x509 -newkey rsa:4096 -nodes \
    -keyout localhost-key.pem \
    -subj "/C=CA/ST=QC/O=My Awesome Company, Inc./CN=myawesomecompany.com" \
    -addext "subjectAltName=DNS:localhost." \
    -out localhost.pem \
    -days 365 \
  && \
  openssl x509 -noout -text -in /certs/localhost.pem

COPY localhost.template /etc/nginx/conf.d/localhost.template
RUN mkdir -p /usr/local/nginx && ln -s /certs /usr/local/nginx/conf
RUN cat <<EOF >> /usr/local/bin/startup.sh
#!/usr/bin/env sh

# failfast
set -e

# trace execution - uncomment to debug
# set -x
envsubst '\$TARGET_SERVER' < /etc/nginx/conf.d/localhost.template > /etc/nginx/conf.d/default.conf
cat /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'
exec nginx -s reload
EOF
RUN chmod u+x /usr/local/bin/startup.sh

EXPOSE 80
EXPOSE 443

CMD /usr/local/bin/startup.sh
