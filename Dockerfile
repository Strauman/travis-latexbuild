FROM gliderlabs/alpine:latest

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

# Install TeX Live 2018 with some basic collections
RUN apk-install perl wget
RUN wget ftp://tug.org/historic/systems/texlive/2018/install-tl-unx.tar.gz \
    && tar --strip-components=1 -xvf install-tl-unx.tar.gz \
    && ./install-tl --profile texlive.profile
ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"
RUN apk-install vim
RUN mkdir /src/
WORKDIR /src
RUN tlmgr install lipsum pgf koma-script xcolor
CMD /bin/sh
