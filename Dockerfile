# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl git-all build-essential
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install afl
ADD . /rasn
WORKDIR /rasn/fuzzing/
COPY /fuzzing/Cargo.toml /rasn/fuzzing/Cargo.toml
RUN ${HOME}/.cargo/bin/cargo afl build

# Package Stage
FROM ubuntu:20.04
COPY --from=builder /rasn/fuzzing/ /
#ENTRYPOINT ["cargo", "afl", "fuzz", "-i", "/in", "-o", "/out"]
#CMD ["/target/debug/fuzz"]
