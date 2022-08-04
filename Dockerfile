#Build Stage
FROM fuzzers/cargo-fuzz:0.10.0 as builder

##Install Build Dependencies
RUN apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y clang

##ADD source code to the build stage
WORKDIR /
ADD . /miniz_oxide
WORKDIR /miniz_oxide

##Build
ENV RUSTFLAGS="-Clink-arg=-fuse-ld=gold"
RUN rustup default nightly
RUN cargo install cargo-fuzz -Z no-index-update
RUN cargo fuzz build inflate_nonwrapping -Zno-index-update

FROM --platform=linux/amd64 ubuntu:20.04
RUN apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y libgcc1 libstdc++6 

COPY --from=builder /miniz_oxide/fuzz/target/x86_64-unknown-linux-gnu/release/inflate_nonwrapping /inflate_nonwrapping

CMD ["/inflate_nonwrapping"]
