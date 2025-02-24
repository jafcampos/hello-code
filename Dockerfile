FROM node:18-alpine
WORKDIR /app
RUN npm init -f && npm install



COPY server.js .
EXPOSE 8080
# Install OneAgent
RUN wget -O /tmp/installer.sh 'https://gqb44926.live.dynatrace.com/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=dt0c01.V6L57NAAELKM4HGLQF3Q3CIW.7T5WJJB6BYSFXFGB5DBQXGSX7YU5VXL4SRAVZQF3BWJAK535ESM75DZNAAZ3XAYT&flavor=musl&include=nodejs' && sh /tmp/installer.sh /home
ENV LD_PRELOAD /home/dynatrace/oneagent/agent/lib64/liboneagentproc.so

CMD ["server.js"]


