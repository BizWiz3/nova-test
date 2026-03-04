# 1. Use Ubuntu 24.04 to get GLIBC 2.39 for Pesde
FROM ubuntu:24.04

# 2. Install all identified dependencies
# - libssl3: Required for Pesde/Lune networking
# - libdbus-1-3: Required for Pesde's credential handling
# - libstdc++6: Required for Luau execution
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libssl3 \
    libdbus-1-3 \
    libstdc++6 \
    git && \
    rm -rf /var/lib/apt/lists/*

# 3. Install Lune
RUN curl -L "https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip" -o lune.zip && \
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/lune && \
    rm lune.zip

# 4. Install Pesde
RUN curl -L "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip" -o pesde.zip && \
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/pesde && \
    rm pesde.zip

# 5. Project Setup
WORKDIR /app

# 6. Verify they work (Both should pass now on 24.04)
RUN lune --version && pesde --version

# 7. Install dependencies
# We set this env var so pesde doesn't try to use a secure keyring in a headless container
ENV PESDE_CONFIG_USER_TOKEN_STORE=file
COPY pesde.toml ./
RUN mkdir -p /root/.pesde && pesde install

# 8. Copy source and Run
COPY . .
ENV PORT=8080
EXPOSE 8080

CMD ["lune", "run", "start"]