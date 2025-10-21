# 1️⃣ Use Node.js as base (n8n requires Node)
FROM node:20-bullseye

# 2️⃣ Set Oracle Instant Client path
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4

# 3️⃣ Install dependencies
RUN apt-get update && \
    apt-get install -y libaio1 libaio-dev unzip wget build-essential --no-install-recommends

# 4️⃣ Copy your local Oracle Instant Client folder
COPY instantclient_21_4 /opt/oracle/instantclient_21_4

# 5️⃣ Install n8n globally
RUN npm install -g n8n

# 6️⃣ Set environment variables for basic auth (override with Render .env)
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=admin

# 7️⃣ Expose n8n default port
EXPOSE 5678

# 8️⃣ Start n8n when container runs
CMD ["n8n", "start"]
