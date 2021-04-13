FROM --platform=linux/amd64 alpine:latest as bzip
ARG TARGETPLATFORM
ARG RESTIC_VERSION

RUN apk add bzip2

RUN export OS=$(echo $TARGETPLATFORM | cut -d"/" -f1) && \
    export ARCH=$(echo $TARGETPLATFORM | cut -d"/" -f2) && \
    wget https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_${OS}_${ARCH}.bz2 && \
    bzip2 -d restic_${RESTIC_VERSION}_${OS}_${ARCH}.bz2 && \
    mv restic_${RESTIC_VERSION}_${OS}_${ARCH} /usr/bin/restic && \
    chmod +x /usr/bin/restic

FROM alpine:latest

COPY --from=bzip /usr/bin/restic /usr/bin/restic

ENTRYPOINT ["/usr/bin/restic"]
