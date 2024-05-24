FROM debian:latest

RUN apt-get update && \
    apt-get install -y mingw-w64 mono-complete
