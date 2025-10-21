# ------------------------------------------
# 1️⃣ Base image with Node.js
# ------------------------------------------
FROM node:22

# ------------------------------------------
# 2️⃣ Set working directory
# ------------------------------------------
WORKDIR /usr/src/app

# ------------------------------------------
# 3️⃣ Copy your Oracle Instant Client from Windows
# ------------------------------------------
COPY instantclient_23_26 /opt/oracle/instantclient_23_26

# ------------------------------------------
# 4️⃣ Install required dependencies
# ------------------------------------------
RUN apt-get update && apt-get install -y libaio1 unzip curl && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------
# 5️⃣ Set environment variables for Oracle
# ------------------------------------------
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_23_26
ENV PATH=/opt/oracle/instantclient_23_26:$PATH
ENV TNS_ADMIN=/opt/oracle/instantclient_23_26/network/admin

# ------------------------------------------
# 6️⃣ Install n8n and oracledb
# ------------------------------------------
RUN npm install -g n8n && \
    npm install oracledb

# ------------------------------------------
# 7️⃣ Copy your app/workflow files
# ------------------------------------------
COPY . .

# ------------------------------------------
# 8️⃣ Expose n8n port and start
# ------------------------------------------
EXPOSE 5678
CMD ["n8n", "start", "--tunnel"]
