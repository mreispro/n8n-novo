FROM docker.n8n.io/n8nio/n8n

# adiciona ferramentas úteis
USER root

RUN set -eux; \
  if ! command -v apk >/dev/null 2>&1; then \
    echo "Esta imagem NÃO é Alpine. Use o Dockerfile para Debian/Ubuntu." >&2; \
    exit 1; \
  fi; \
  apk add --no-cache \
    mariadb-client \        # fornece mariadb, mariadb-admin (substitui mysql/mysqladmin)
#    busybox-extras \        # fornece nc (netcat) e traceroute
    iputils \               # fornece ping
    mtr \                   # mtr (traceroute interativo)
    bash \                  # shell confortável p/ scripts
    curl;                   # útil p/ testes HTTP/healthchecks

# (opcional) garante pasta do usuário do n8n com permissão correta
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

USER node

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD


ARG ENCRYPTION_KEY

ENV N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

CMD ["n8n start"]
