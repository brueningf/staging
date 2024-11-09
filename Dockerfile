FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git sudo build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev curl \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-add-repository -y ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install -y python3 python3-pip ansible neovim && \
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
