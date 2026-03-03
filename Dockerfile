FROM debian:bookworm-slim

# 1. Install system dependencies
RUN apt-get update && \
    apt-get install -y curl unzip ca-certificates libssl-dev git && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lune
RUN curl -L https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip -o lune.zip && \
    # -j ignores internal folders and extracts the 'lune' binary to the root
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/lune && \
    rm lune.zip

# 3. Install Pesde
RUN curl -L https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip -o pesde.zip && \
    # -j ensures the 'pesde' binary is extracted directly, even if it's inside a folder in the zip
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/pesde && \
    rm pesde.zip

# 4. Project Setup
WORKDIR /app

# 5. Verify they are actually installed (This will show in your GitHub logs)
RUN lune --version && pesde --version

# 6. Install dependencies
COPY pesde.toml ./
RUN pesde install

# 7. Copy the rest of your source code
COPY . .

# 8. Set the environment variable for the port (Render/Railway use this)
ENV PORT=8080
EXPOSE 8080

# 9. Run the application
CMD ["lune", "run", "start"]