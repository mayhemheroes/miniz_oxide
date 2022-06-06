#Build Stage
FROM fuzzers/cargo-fuzz:0.10.0 as builder

##Install Build Dependencies
RUN apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y git clang

##ADD source code to the build stage
WORKDIR /
ADD https://api.github.com/repos/ennamarie19/miniz_oxide/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/ennamarie19/miniz_oxide.git
WORKDIR /miniz_oxide

##Build
ENV RUSTFLAGS="-Clink-arg=-fuse-ld=gold"
RUN rustup default nightly
RUN cargo install cargo-fuzz -Z no-index-update
RUN cargo fuzz build inflate_nonwrapping -Zno-index-update

##Prepare all library dependencies for copy
RUN mkdir /deps
RUN cp `ldd /miniz_oxide/fuzz/target/x86_64-unknown-linux-gnu/release/inflate_nonwrapping | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' \ 
| sort | uniq` /deps 2>/dev/null || :

FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /miniz_oxide/fuzz/target/x86_64-unknown-linux-gnu/release/inflate_nonwrapping /inflate_nonwrapping
COPY --from=builder /deps /usr/lib

CMD ["/inflate_nonwrapping"]
