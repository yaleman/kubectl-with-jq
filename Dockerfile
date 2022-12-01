FROM registry.suse.com/bci/bci-base:15.4 AS build

ARG GITHUB_SHA="${GITHUB_SHA}"

LABEL com.repository="https://github.com/yaleman/kubectl-with-jq"
LABEL com.git-commit="${GITHUB_SHA}"

WORKDIR /

RUN set -x \
 && zypper -n install curl jq \
 && if [ "$(uname -m)" == "aarch64" ]; then \
    ARCH="arm64"; \
    else \
    ARCH="amd64"; \
    fi \
 && curl -fsSLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
 && chmod +x kubectl \
 && useradd -u 1000 -U -m kubectl

FROM scratch
WORKDIR /
COPY --from=build /kubectl /bin/kubectl
COPY --from=build /lib64/libreadline.so.7 /lib64/libreadline.so.7
COPY --from=build /lib64/libm.so.6 /lib64/libm.so.6
COPY --from=build /lib64/libdl.so.2 /lib64/libdl.so.2
COPY --from=build /lib64/libc.so.6 /lib64/libc.so.6
COPY --from=build /lib64/libtinfo.so.6 /lib64/libtinfo.so.6
COPY --from=build /usr/lib64/libjq.so.1 /usr/lib64/libjq.so.1
COPY --from=build /usr/lib64/libonig.so.4 /usr/lib64/libonig.so.4
COPY --from=build /lib/ld-linux-* /lib/

COPY --from=build /usr/bin/jq /bin/jq
COPY --from=build /usr/bin/sh /bin/sh
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
COPY testscript.sh /usr/local/bin/
USER kubectl
ENTRYPOINT ["/bin/sh"]