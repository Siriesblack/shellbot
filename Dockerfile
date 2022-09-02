FROM node:14

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get update &&  apt-get install -y  curl lsb-release

# add mkvtoolnix
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

RUN apt-get update \
    && apt-get -y install \
    --no-install-recommends \
    wget \
    mediainfo \
    neofetch \
    jq \
    aria2 \
    golang \
    python3 \
    python3-pip \
    p7zip-full \
    make \
    nginx \
    git \
    gcc \
    g++ \
    unzip \
    busybox \
    build-essential \
    gnupg2 \
    openssl \
    ffmpeg \
    youtube-dl \
    zip \
    ca-certificates \
    && update-ca-certificates \
    && curl  \
    https://mega.nz/linux/MEGAsync/Debian_9.0/i386/megacmd-Debian_9.0_i386.deb \
    --output /tmp/megacmd.deb \
    && apt install /tmp/megacmd.deb -y --allow-remove-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/megacmd.*
#gdrive setupz
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/Jitendra7007/gdrive
RUN echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup

#Rclone
RUN curl https://rclone.org/install.sh | bash 
  # setup workdir
WORKDIR /bot
COPY . .
RUN npm install
CMD ["bash", "start.sh"]

