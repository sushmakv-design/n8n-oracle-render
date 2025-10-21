# Use Node 20 (supported by n8n)
FROM node:20

# Install Oracle Instant Client dependencies
RUN apt-get update && apt-get install -y libaio1 unzip wget

# Download and install Oracle Instant Client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.x64-23.8.0.0.0dbru.zip -O /tmp/instantclient.zip \
    && unzip /tmp/instantclient.zip -d /opt \
    && rm /tmp/instantclient.zip \
    && ln -s /opt/instantclient_23_8 /opt/instantclient

ENV LD_LIBRARY_PATH=/opt/instantclient
ENV PATH=$PATH:/opt/instantclient

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and workflow.json
COPY package.json workflow.json ./

# Install dependencies
RUN npm install

# Expose port 5678
EXPOSE 5678

# Start n8n
CMD ["n8n", "start", "--tunnel"]
