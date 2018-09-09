FROM gliderlabs/alpine:latest

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

# Install TeX Live 2016 with some basic collections
RUN apk-install perl wget
RUN wget ftp://tug.org/historic/systems/texlive/2018/install-tl-unx.tar.gz \
    && tar --strip-components=1 -xvf install-tl-unx.tar.gz \
    && ./install-tl --profile texlive.profile
# RUN tlmgr install lipsum pgf scrextend koma-script xcolor
RUN apk-install vim
ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"
mkdir /src/
WORKDIR /src
CMD /bin/sh
