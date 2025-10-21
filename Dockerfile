# ------------------------------
# Dockerfile for n8n with Oracle
# ------------------------------

# Use Node 20 (supported by n8n)
FROM node:20

# Install system dependencies for Oracle Instant Client
RUN apt-get update && \
    apt-get install -y libaio1 unzip wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install Oracle Instant Client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.x64-23.8.0.0.0dbru.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /opt && \
    rm /tmp/instantclient.zip && \
    ln -s /opt/instantclient_23_8 /opt/instantclient

# Set environment variables for Oracle
ENV LD_LIBRARY_PATH=/opt/instantclient
ENV PATH=$PATH:/opt/instantclient

# Set working directory
WORKDIR /usr/src/app

# Copy package.json, workflow.json, and .env
COPY package.json workflow.json .env ./

# Install dependencies
RUN npm install

# Expose default n8n port
EXPOSE 5678

# Load environment variables from .env file (optional for local testing)
# If using Render, environment variables from the dashboard will override
ENV N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE}
ENV N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
ENV N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
ENV ORACLE_USER=${ORACLE_USER}
ENV ORACLE_PASSWORD=${ORACLE_PASSWORD}
ENV ORACLE_HOST=${ORACLE_HOST}
ENV ORACLE_PORT=${ORACLE_PORT}
ENV ORACLE_SERVICE=${ORACLE_SERVICE}

# Start n8n with tunnel mode
CMD ["n8n", "start", "--tunnel"]
