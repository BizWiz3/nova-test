# Ubuntu 22.04 (Jammy) is perfect for these binaries
FROM ubuntu:22.04

# 1. Install system dependencies
# Added libdbus-1-3 to satisfy the Pesde dependency
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libssl3 \
    libdbus-1-3 \
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
# Lune showed '0.10.4' last time, now Pesde should show its version too
RUN lune --version && pesde --version

# 6. Install dependencies
COPY pesde.toml ./
# Ensure the pesde directory exists for caching
RUN mkdir -p /root/.pesde && pesde install

# 7. Copy the rest of your source code
COPY . .

# 8. Environment
ENV PORT=8080
EXPOSE 8080

# 9. Run the application
CMD ["lune", "run", "start"]