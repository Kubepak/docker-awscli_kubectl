FROM debian:stable-slim as awscli-installer

RUN apt-get update \
 && apt-get install -y curl unzip \
 && curl -sSfL -o "awscli-exe-linux-x86_64.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
 && unzip "awscli-exe-linux-x86_64.zip" \
 && ./aws/install --bin-dir "/aws-cli-bin/"

FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
 && apt-get install -y curl

# awscli
COPY --from=awscli-installer "/usr/local/aws-cli/" "/usr/local/aws-cli/"
COPY --from=awscli-installer "/aws-cli-bin/" "/usr/local/bin/"

# kubectl
RUN __version="$(curl -sSfL https://dl.k8s.io/release/stable.txt)" \
 && curl -sSfL -o "/usr/local/bin/kubectl" "https://dl.k8s.io/release/${__version}/bin/linux/amd64/kubectl" \
 && chmod +x "/usr/local/bin/kubectl"
