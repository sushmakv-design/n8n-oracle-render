# ------------------------------------------
# 1️⃣ Use prebuilt image with Oracle Instant Client
# ------------------------------------------
FROM ghcr.io/gvenzl/oracle-instantclient:23 AS base

# ------------------------------------------
# 2️⃣ Use official Node image for n8n
# ------------------------------------------
FROM node:22

# Copy Oracle libraries from the instant client layer
COPY --from=base /usr/lib/oracle /usr/lib/oracle
COPY --from=base /usr/share/oracle /usr/share/oracle
COPY --from=base /opt/oracle /opt/oracle

# Set environment for Oracle
ENV LD_LIBRARY_PATH=/usr/lib/oracle/23/client64/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/lib/oracle/23/client64/bin:$PATH
ENV TNS_ADMIN=/usr/lib/oracle/23/client64/network/admin

# ------------------------------------------
# 3️⃣ Install dependencies
# ------------------------------------------
RUN apt-get update && apt-get install -y \
    libaio1 unzip curl wget && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------
# 4️⃣ Setup n8n
# ------------------------------------------
WORKDIR /usr/src/app

# Copy your workflow/project files (if any)
COPY package*.json ./

# Install n8n and oracledb driver
RUN npm install -g n8n && \
    npm install oracledb

# Copy the rest of your app (optional)
COPY . .

# ------------------------------------------
# 5️⃣ Expose n8n port and run
# ------------------------------------------
EXPOSE 5678

# For Render deployment or local testing
CMD ["n8n", "start", "--tunnel"]
