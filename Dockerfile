FROM node:16-alpine as builder
# Set the working directory to /app inside the container
WORKDIR /app
# Copy app files
COPY . .
# Install dependencies (npm ci makes sure the exact versions in the lockfile gets installed)
RUN npm ci 
# Build the app
RUN npm run build

# Bundle static assets with nginx
FROM nginx:1.21.0-alpine as production
# Copy built assets from `builder` image
COPY --from=builder /app/dist/mflix /usr/share/nginx/html

# Expose port
EXPOSE 80
# Install OneAgent
RUN wget -O /tmp/installer.sh 'https://gqb44926.live.dynatrace.com/api/v1/deployment/installer/agent/unix/paas-sh/latest?Api-Token=dt0c01.V6L57NAAELKM4HGLQF3Q3CIW.7T5WJJB6BYSFXFGB5DBQXGSX7YU5VXL4SRAVZQF3BWJAK535ESM75DZNAAZ3XAYT&flavor=musl&include=nginx' && sh /tmp/installer.sh /home

ENV LD_PRELOAD /home/dynatrace/oneagent/agent/lib64/liboneagentproc.so
# Start nginx
CMD ["nginx", "-g", "daemon off;"]
