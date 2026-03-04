# We use 20.04 because it contains the libssl1.1 that these binaries require
FROM ubuntu:20.04

# 1. Install system dependencies
# We use DEBIAN_FRONTEND=noninteractive to prevent the build from hanging on timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libssl-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lune
# Using quotes for the URL to avoid shell issues with special characters
RUN curl -L "https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip" -o lune.zip && \
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/bin/lune && \
    rm lune.zip

# 3. Install Pesde
RUN curl -L "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip" -o pesde.zip && \
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/bin/pesde && \
    rm pesde.zip

# 4. Project Setup
WORKDIR /app

# 5. Verify they work
# If this fails now, it will give a descriptive error about which library is missing
RUN lune --version && pesde --version

# 6. Install dependencies
COPY pesde.toml ./
# Pesde requires a home directory to store its package cache
RUN mkdir -p /root/.pesde && pesde install

# 7. Copy the rest of your source code
COPY . .

# 8. Set Port
ENV PORT=8080
EXPOSE 8080

# 9. Run the application
CMD ["lune", "run", "start"]