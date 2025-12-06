FROM debian:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y mingw-w64 mono-complete && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY dockompiler.sh /usr/local/bin/dockompiler
COPY examples /app/examples

RUN chmod +x /usr/local/bin/dockompiler

ENTRYPOINT ["dockompiler"]