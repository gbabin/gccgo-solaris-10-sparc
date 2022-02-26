# Go compiler for sparc-sun-solaris2.10

* C/C++/Go compiler for Solaris 10 on SPARC (32-bit static binaries)
* Supports Go 1.12.2 (as supported by GCC 9) (GOARCH=sparc GOOS=solaris)
* Cross-compiler hosted on GNU/Linux (Rocky Linux 8)
* Packaged in a Docker container

## Usage

1. Get include and lib files  
   On target (to create `target.tar.gz`):

        ./archive-target.sh

1. Transfer `target.tar.gz` to local folder

1. Download `binutils-2.38.tar.gz` and `gcc-9.4.0.tar.gz` to local folder

1. Build Docker image  
   On local host:

        ./build-docker-image.sh

1. Start shell in container  
   On local host, in Go program source directory:

        ./launch-with-pwd-in-tmp.sh

1. Compile Go program  
   Inside container:

        sparc-sun-solaris2.10-gccgo -m32 -static-libgcc -static-libgo -o hello hello.go -Wl,-dy -lnsl -lsocket -lrt -lsendfile

1. Run Go program on target

        $ ./hello
        Hello, World!

        $ ldd hello
                libnsl.so.1      => /usr/lib/libnsl.so.1
                libsocket.so.1   => /usr/lib/libsocket.so.1
                librt.so.1       => /usr/lib/librt.so.1
                libsendfile.so.1 => /usr/lib/libsendfile.so.1
                libpthread.so.1  => /usr/lib/libpthread.so.1
                libm.so.2        => /usr/lib/libm.so.2
                libc.so.1        => /usr/lib/libc.so.1
                libmp.so.2       => /usr/lib/libmp.so.2
                libmd.so.1       => /usr/lib/libmd.so.1
                libscf.so.1      => /usr/lib/libscf.so.1
                libaio.so.1      => /usr/lib/libaio.so.1
                libdoor.so.1     => /usr/lib/libdoor.so.1
                libuutil.so.1    => /usr/lib/libuutil.so.1
                libgen.so.1      => /usr/lib/libgen.so.1
                /lib/libm/libm_hwcap1.so.2
                /platform/sun4v/lib/libc_psr.so.1
                /platform/sun4v/lib/libmd_psr.so.1

## Acknowledgements

<https://ggolang.blogspot.com/2015/05/gccgo-gcc510-cross-compile-for-sparc.html>
