# Node version supported by n8n
FROM node:22

# Install OS dependencies
RUN apt-get update && apt-get install -y libaio1 unzip wget && rm -rf /var/lib/apt/lists/*

# Download Oracle Instant Client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.x64-23.8.0.0.0dbru.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /opt && \
    rm /tmp/instantclient.zip && \
    ln -s /opt/instantclient_23_8 /opt/instantclient

# Set environment variables
ENV LD_LIBRARY_PATH=/opt/instantclient
ENV PATH=$PATH:/opt/instantclient

# Working directory
WORKDIR /usr/src/app

# Copy project files
COPY package.json workflow.json .env ./

# Install Node dependencies
RUN npm install

# Expose n8n port
EXPOSE 5678

# Start n8n with tunnel
CMD ["n8n", "start", "--tunnel"]
