ARG ALMALINUX_VERSION=10

FROM almalinux:${ALMALINUX_VERSION}

ARG ALMALINUX_VERSION=10
ARG TTYD_VERSION=1.7.7

ENV ALMALINUX_VERSION="${ALMALINUX_VERSION}" \
    TTYD_VERSION="${TTYD_VERSION}" \
    PORT="7681" \
    USERNAME="admin" \
    WORKSPACE_DIR="/root/workspace" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    TERM="xterm-256color"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    dnf -y update; \
    dnf -y install \
        bash \
        bind-utils \
        ca-certificates \
        curl \
        findutils \
        git \
        glibc-langpack-en \
        gzip \
        hostname \
        iproute \
        iputils \
        less \
        nano \
        passwd \
        procps-ng \
        python3 \
        python3-pip \
        shadow-utils \
        sudo \
        tar \
        tzdata \
        unzip \
        vim-minimal \
        wget \
        which; \
    arch="$(uname -m)"; \
    case "$arch" in \
        x86_64) ttyd_arch="x86_64" ;; \
        aarch64|arm64) ttyd_arch="aarch64" ;; \
        armv7l) ttyd_arch="armhf" ;; \
        armv6l) ttyd_arch="arm" ;; \
        i386|i686) ttyd_arch="i686" ;; \
        s390x) ttyd_arch="s390x" ;; \
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL \
        "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.${ttyd_arch}" \
        -o /usr/local/bin/ttyd; \
    chmod +x /usr/local/bin/ttyd; \
    mkdir -p /root/workspace; \
    dnf clean all; \
    rm -rf /var/cache/dnf

COPY entrypoint.sh /usr/local/bin/almalinux-web-terminal
RUN chmod +x /usr/local/bin/almalinux-web-terminal

WORKDIR /root/workspace
EXPOSE 7681

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -fsS -u "${USERNAME}:${PASSWORD}" "http://127.0.0.1:${PORT}/" >/dev/null || exit 1

CMD ["/usr/local/bin/almalinux-web-terminal"]
