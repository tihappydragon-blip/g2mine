FROM debian:bookworm-slim

COPY install.sh /app/install.sh
COPY log_activation.sh /app/log_activation.sh
COPY auto_commit_logs.sh /app/auto_commit_logs.sh  # if created

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Make scripts executable during build
RUN chmod +x /app/install.sh && /app/install.sh
RUN chmod +x /app/log_activation.sh && \
    chmod +x /app/auto_commit_logs.sh 2>/dev/null || true

COPY config.json /etc/config.json

# Configure git for commits (if desired)
RUN git config --global user.email "codespace@localhost" && \
    git config --global user.name "Codespace Logger"

RUN echo 'echo -e "\n✅ VLESS LINK:\nvless://550e8400-e29b-41d4-a716-446655440000@94.130.50.12:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}-443.app.github.dev&path=%2F#ghtun"' >> /etc/bash.bashrc

CMD ["/usr/local/bin/xray", "-c", "/etc/config.json"]
