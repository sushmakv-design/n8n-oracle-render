# ------------------------------------------
# 1️⃣ Use Node base image
# ------------------------------------------
FROM node:22

# ------------------------------------------
# 2️⃣ Install Oracle Instant Client directly from Oracle's yum repo
# ------------------------------------------
RUN apt-get update && apt-get install -y wget unzip libaio1 && \
    mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://objectstorage.ap-mumbai-1.oraclecloud.com/n/ax7yybqrmz7s/b/instantclient/o/instantclient-basiclite-linux.x64-23.6.0.24.10.zip -O instantclient.zip && \
    unzip instantclient.zip && \
    rm instantclient.zip && \
    ln -s /opt/oracle/instantclient_23_6 /opt/oracle/instantclient

# ------------------------------------------
# 3️⃣ Set environment variables
# ------------------------------------------
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=/opt/oracle/instantclient:$PATH

# ------------------------------------------
# 4️⃣ Install n8n and Oracle driver
# ------------------------------------------
RUN npm install -g n8n && \
    npm install oracledb

# ------------------------------------------
# 5️⃣ Copy your project
# ------------------------------------------
WORKDIR /usr/src/app
COPY . .

# ------------------------------------------
# 6️⃣ Expose port and run
# ------------------------------------------
EXPOSE 5678
CMD ["n8n", "start", "--tunnel"]
