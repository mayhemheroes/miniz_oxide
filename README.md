Main library [![Crates.io](https://img.shields.io/crates/v/miniz_oxide.svg)](https://crates.io/crates/miniz_oxide)[![Docs](https://docs.rs/miniz_oxide/badge.svg)](https://docs.rs/miniz_oxide)

C API [![Crates.io](https://img.shields.io/crates/v/miniz_oxide_c_api.svg)](https://crates.io/crates/miniz_oxide_c_api)[![Docs](https://docs.rs/miniz_oxide_c_api/badge.svg)](https://docs.rs/miniz_oxide_c_api)

# miniz_oxide
Pure rust replacement for the [miniz](https://github.com/richgel999/miniz) deflate/zlib encoder/decoder using no unsafe code. Builds in [no_std](https://docs.rust-embedded.org/book/intro/no-std.html) mode, though requires the use of `alloc` and `collections` crates or preallocated memory slices.

This project is organized into a C API shell and a rust crate.
The Rust crate is found in the [miniz_oxide subdirectory](https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide). See the subdirectory for the full README.

For a friendlier streaming API using readers and writers, [flate2](https://crates.io/crates/flate2) can be used, which can use miniz_oxide as a rust-only back-end.

## miniz_oxide_C_API
The C API is intended to replicate the API exported from miniz, and in turn also part of zlib. The C header is generated using [cbindgen](https://github.com/eqrion/cbindgen). The current implementation has not seen a lot of testing outside of automated tests, is a bit weak in documentation and should be seen as experimental.

The data structures do not share the exact same layout that is specified in miniz.h (from the original miniz), and should thus be allocated via the included functions.

### API documentation

TODO

### Testing

```bash
$ cargo test
$ ./test.sh
```

### Including in C/C++ projects

Link against the `libminiz_oxide_c_api.a` generated by `build.sh`. The generated header that can be used is `miniz.h` (using the original miniz headers may or may not work), which currently also uses `miniz_extra_defs.h` for some static definitions.

### Cargo-fuzz testing

Install fuzzer:
```bash
$ cargo install cargo-fuzz
```

Currently the inflate_nonwrapping and roundtrip_target fuzz targets work
```bash
$ cargo +nightly fuzz run inflate_nonwrapping
```

### License
This library (excluding the original miniz C code used for tests) is dual licensed under the MIT license and Apache 2.0 license. The library is based on the [miniz][MIT license](https://github.com/richgel999/miniz) C library by Rich Geldreich which is released under the MIT license.
