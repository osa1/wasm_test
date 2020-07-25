This only works with emcc. I think the problem is similar to the one in
`rs_static_lib`: the archive file doesn't really include libc. So we have to
link it manually, which is what emcc does.

I think one way to fix this would be to use musl sources from wasi-sdk.
