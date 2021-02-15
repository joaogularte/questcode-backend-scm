FROM node:15.7.0-alpine3.10 AS builder

ARG HOME="/app"
ARG PUID=2000
ARG PGUID=2000

RUN addgroup --gid ${PGUID} questcode-backend-scm && \
  adduser -D -u ${PUID} -G questcode-backend-scm -s /bin/bash -h ${HOME} questcode-backend-scm

USER questcode-backend-scm:questcode-backend-scm

RUN mkdir -p /app/src
WORKDIR ${HOME}/src
COPY --chown=questcode-backend-scm:questcode-backend-scm package*.json /app/src/
RUN npm install
COPY --chown=questcode-backend-scm:questcode-backend-scm .  /app/src/

FROM node:15.7.0-alpine3.10 as server

ARG HOME="/app"
ARG PUID=2000
ARG PGUID=2000

RUN addgroup --gid ${PGUID} questcode-backend-scm && \
  adduser -D -u ${PUID} -G questcode-backend-scm -s /bin/bash -h ${HOME} questcode-backend-scm

USER questcode-backend-scm:questcode-backend-scm

WORKDIR /app
COPY --chown=questcode-backend-scm:questcode-backend-scm --from=builder /app/src /app
EXPOSE 3030
CMD ["npm", "start"]
