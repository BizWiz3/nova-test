# 22.04 provides GLIBC 2.35, which satisfies the 'GLIBC_2.34' requirement
FROM ubuntu:22.04

# 1. Install system dependencies
# libssl3 is the crucial one for Ubuntu 22.04+
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libssl3 \
    git && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lune
RUN curl -L "https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip" -o lune.zip && \
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/lune && \
    rm lune.zip

# 3. Install Pesde
RUN curl -L "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip" -o pesde.zip && \
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/pesde && \
    rm pesde.zip

# 4. Project Setup
WORKDIR /app

# 5. Verify they work
# If this fails, the error message in the logs will now be very specific
RUN lune --version && pesde --version

# 6. Install dependencies
COPY pesde.toml ./
# Create the config directory for pesde to prevent permission errors
RUN mkdir -p /root/.pesde && pesde install

# 7. Copy the rest of your source code
COPY . .

# 8. Set Port
ENV PORT=8080
EXPOSE 8080

# 9. Run the application
CMD ["lune", "run", "start"]