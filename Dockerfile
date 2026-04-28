FROM ubuntu:24.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
        tmux \
        iproute2 \
        vim \
        nano \
        sudo \
        jq \
        bc \
        python3 \
        net-tools \
        iputils-ping \
        dnsutils \
        traceroute \
        curl \
        wget \
        telnet \
        tcpdump \
        nmap \
        netcat-openbsd \
        openssh-client \
        sshpass \
        iftop \
        iperf3 \
        htop \
        bridge-utils \
        ethtool \
        whois \
        sqlite3 \
        lldpd \
    && apt -y autoremove \
    && apt clean all \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu
USER ubuntu
WORKDIR /home/ubuntu

RUN echo 'export PS1="\u@nettools:\w\$ "' >> /home/ubuntu/.bashrc

CMD ["/bin/bash", "-c", "sleep infinity"]
