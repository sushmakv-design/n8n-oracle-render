# Use Ruby as base
FROM ruby:3.0

# Set Oracle library path
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4

# Install required packages
RUN apt-get update && \
    apt-get install -y libpq-dev zlib1g-dev build-essential shared-mime-info libaio1 libaio-dev --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy your local Oracle Instant Client folder into the image
COPY instantclient_21_4 /opt/oracle/instantclient_21_4

# Clean up unnecessary packages
RUN apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/cache/apt

# Set workdir
WORKDIR /usr/src/app

# Copy your n8n workflow/project files
COPY . .

# Expose n8n default port
EXPOSE 5678

# Set entrypoint to n8n
CMD ["n8n", "start"]
