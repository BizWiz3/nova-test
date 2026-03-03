
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 3. Install Lune (The Runtime)
RUN curl -L https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip -o lune.zip && \
    unzip lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/ && \
    rm lune.zip

# 4. Install Pesde (The Package Manager)
RUN curl -L https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip -o pesde.zip && \
    unzip pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/ && \
    rm pesde.zip

# 5. Set the working directory (The "Project Folder" inside the container)
WORKDIR /app

# 6. Copy ONLY package files first
COPY pesde.toml .

# 7. Install dependencies using Pesde
RUN pesde install

# 8. Copy the rest of your source code
COPY . .

# 9. Expose the port 
EXPOSE 8080

# 10. Run the application
# We use the shell form to allow environment variable expansion if needed
CMD ["lune", "run", "start"]