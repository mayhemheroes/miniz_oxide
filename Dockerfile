#Build Stage
FROM rust:latest AS builder

##ADD source code to the build stage
WORKDIR /
ADD . /miniz_oxide
WORKDIR /miniz_oxide

##Build
RUN rustup override set nightly
RUN cargo install cargo-fuzz
RUN cargo fuzz build inflate_nonwrapping

FROM --platform=linux/amd64 ubuntu:22.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libgcc-s1 libstdc++6

COPY --from=builder /miniz_oxide/fuzz/target/x86_64-unknown-linux-gnu/release/inflate_nonwrapping /inflate_nonwrapping

CMD ["/inflate_nonwrapping"]
