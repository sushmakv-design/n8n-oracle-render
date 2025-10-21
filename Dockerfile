# 1️⃣ Use Node.js base for n8n
FROM node:20-bullseye

# 2️⃣ Set Oracle Instant Client environment variable
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4

# 3️⃣ Install required packages and download/unzip Instant Client
RUN apt-get update && \
    apt-get install -y libaio1 libaio-dev unzip wget build-essential libpq-dev zlib1g-dev --no-install-recommends && \
    mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-basic-linux.x64-21.4.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-sdk-linux.x64-21.4.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-21.4.0.0.0dbru.zip && \
    unzip instantclient-sdk-linux.x64-21.4.0.0.0dbru.zip && \
    unzip instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip && \
    rm -rf instantclient-*.zip && \
    apt-get remove -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt

# 4️⃣ Install n8n globally
RUN npm install -g n8n

# 5️⃣ Set working directory for workflows
WORKDIR /data

# 6️⃣ Expose default n8n port
EXPOSE 5678

# 7️⃣ Default command to run n8n
CMD ["n8n"]
