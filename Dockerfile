FROM debian:bookworm-slim

# 1. Install system dependencies + libssl (CRITICAL for pesde/lune networking)
RUN apt-get update && \
    apt-get install -y curl unzip ca-certificates libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lune (The Runtime) - Standardized v0.10.4
RUN curl -L https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip -o lune.zip && \
    unzip lune.zip && \
    # Lune unzips as a single file 'lune', so this is fine
    chmod +x lune && \
    mv lune /usr/local/bin/ && \
    rm lune.zip

# 3. Install Pesde (The Package Manager) - Fixed Path Logic
RUN curl -L https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip -o pesde.zip && \
    # We unzip into a temp folder to ensure we find the binary regardless of subfolders
    unzip pesde.zip -d pesde_temp && \
    # Find the file named 'pesde' anywhere in the unzipped folder and move it
    find pesde_temp -type f -name "pesde" -exec mv {} /usr/local/bin/pesde \; && \
    chmod +x /usr/local/bin/pesde && \
    rm -rf pesde.zip pesde_temp

# 4. Project Setup
WORKDIR /app

# 5. Install dependencies
# We copy pesde.toml AND pesde.lock (if you have one) to speed up builds
COPY pesde.toml ./
# If you don't have a lockfile yet, this command won't fail
RUN pesde install

# 6. Copy the rest of your source code
COPY . .

# 7. Final config
EXPOSE 8080

# 8. Run the application
# Use 'lune run start' (Ensure 'start.luau' exists or it's a pesde script)
CMD ["lune", "run", "start"]