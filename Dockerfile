FROM alpine:3.18.4

# Available architectures: x86_64, x86, aarch64, armv7a, riscv64, powerpc64le, powerpc.
ARG ARCH=x86_64
ARG VERSION=0.12.0-dev.1303+8f4853369

RUN apk update && \
    apk add --no-cache curl

RUN curl https://ziglang.org/builds/zig-linux-${ARCH}-${VERSION}.tar.xz -o zig-linux-${ARCH}-${VERSION}.tar.xz && \
    tar -xf zig-linux-${ARCH}-${VERSION}.tar.xz && \
    mv zig-linux-${ARCH}-${VERSION} /usr/local/zig && \
    rm zig-linux-${ARCH}-${VERSION}.tar.xz

ENTRYPOINT ["/usr/local/zig/zig"]

CMD ["--help"]
