FROM ubuntu:22.04

# 1. Install system dependencies
# We add libssl3 and zlib1g which are common Rust/Luau binary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libssl3 \
    zlib1g \
    git && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lune (Quoted URL + explicit version)
RUN curl -L "https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip" -o lune.zip && \
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/lune && \
    rm lune.zip

# 3. Install Pesde (Quoted URL + explicit version)
# Note: Pesde 0.7.x is older; consider 0.9.1+ if possible, but keeping your version for now
RUN curl -L "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip" -o pesde.zip && \
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/pesde && \
    rm pesde.zip

# 4. Project Setup
WORKDIR /app

# 5. Verify via absolute paths (to ensure it's not a PATH hashing issue)
RUN /usr/local/bin/lune --version && /usr/local/bin/pesde --version

# 6. Install dependencies
COPY pesde.toml ./
# Pesde often needs a home directory to store its registry index
RUN mkdir -p /root/.pesde && pesde install

# 7. Copy the rest of your source code
COPY . .

# ENV PORT=8080
EXPOSE 8080

CMD ["lune", "run", "start"]