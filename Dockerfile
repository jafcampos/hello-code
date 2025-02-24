FROM registry.access.redhat.com/ubi9/nodejs-20:latest AS build-env
WORKDIR /app
RUN npm init -f && npm install
COPY server.js .

# Use a small distroless image for as runtime image
FROM gcr.io/distroless/nodejs20-debian12
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 8080
# Install OneAgent
# RUN wget -O /tmp/installer.sh 'https://gqb44926.live.dynatrace.com/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=dt0c01.V6L57NAAELKM4HGLQF3Q3CIW.7T5WJJB6BYSFXFGB5DBQXGSX7YU5VXL4SRAVZQF3BWJAK535ESM75DZNAAZ3XAYT&flavor=musl&include=nginx' && sh /tmp/installer.sh /home
# ENV LD_PRELOAD /home/dynatrace/oneagent/agent/lib64/liboneagentproc.so

CMD ["server.js"]


