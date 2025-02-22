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
RUN echo $$DT_ENDPOINT
RUN wget -O /tmp/installer.sh '$DT_ENDPOINT/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=$DT_API_TOKEN&flavor=musl&include=nodejs' && sh /tmp/installer.sh /hom

ENV LD_PRELOAD /home/dynatrace/oneagent/agent/lib64/liboneagentproc.so
CMD ["server.js"]
