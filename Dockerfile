FROM rockylinux:8

RUN dnf update -y \
 && dnf install -y 'dnf-command(config-manager)' \
 && dnf config-manager --set-enabled powertools \
 && dnf update -y \
 && dnf groupinstall -y "Development Tools" \
 && dnf install -y texinfo gmp gmp-devel mpfr mpfr-devel libmpc libmpc-devel \
 && dnf clean all

# from archive-target.sh run on the target
ADD target.tar.gz /imported/target/

ENV PREFIX  /opt/cross
ENV SYSROOT /opt/cross/sysroot
ENV TARGET  sparc-sun-solaris2.10

RUN mkdir $PREFIX                                             \
 && mkdir $SYSROOT                                            \
 && mkdir {$SYSROOT/usr,$SYSROOT/usr/sfw,$SYSROOT/usr/local}  \
 && mv /imported/target/lib               $SYSROOT/           \
 && mv /imported/target/usr/lib           $SYSROOT/usr/       \
 && mv /imported/target/usr/include       $SYSROOT/usr/       \
 && mv /imported/target/usr/platform      $SYSROOT/usr/       \
 && mv /imported/target/usr/local/lib     $SYSROOT/usr/local/ \
 && mv /imported/target/usr/local/include $SYSROOT/usr/local/ \
 && mv /imported/target/usr/sfw/lib       $SYSROOT/usr/sfw/   \
 && mv /imported/target/usr/sfw/include   $SYSROOT/usr/sfw/   \
 && rm -r /imported

# https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz
ADD binutils-2.38.tar.gz /build/

WORKDIR /build/binutils-build
RUN ../binutils-2.38/configure -target=$TARGET --prefix=$PREFIX -with-sysroot=$SYSROOT -v \
 && make \
 && make install

# https://ftp.gnu.org/gnu/gcc/gcc-9.4.0/gcc-9.4.0.tar.gz
ADD gcc-9.4.0.tar.gz /build/

WORKDIR /build/gcc-build
RUN ../gcc-9.4.0/configure --enable-obsolete \
                           --target=$TARGET --with-gnu-as --with-gnu-ld  --prefix=$PREFIX \
                           --with-sysroot=$SYSROOT --disable-libgcj --enable-languages=c,c++,go -v \
 && make \
 && make install

RUN rm -r /build

ENV PATH $PREFIX/bin:$PATH
