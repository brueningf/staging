FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git sudo build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-add-repository -y ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install -y ansible neovim && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS user
ARG TAGS
RUN addgroup --gid 1000 fb
RUN adduser --gecos fb --uid 1000 --gid 1000 --disabled-password fb
RUN echo '%fb ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER fb
WORKDIR /home/fb

FROM user
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
