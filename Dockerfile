FROM gliderlabs/alpine:latest

RUN mkdir /tmp/install-tl-unx

WORKDIR /tmp/install-tl-unx

COPY texlive.profile .

# Install TeX Live 2018 with some basic collections
RUN apk-install perl wget vim
RUN wget ftp://tug.org/historic/systems/texlive/2018/install-tl-unx.tar.gz \
    && tar --strip-components=1 -xvf install-tl-unx.tar.gz \
    && ./install-tl --profile texlive.profile
ENV PATH="/usr/local/texlive/2018/bin/x86_64-linuxmusl:${PATH}"
COPY execute_tests.sh "/usr/bin/execute_tests"
RUN chmod +x "/usr/bin/execute_tests"
RUN tlmgr install latexmk
RUN mkdir /repo/
WORKDIR /repo
RUN tlmgr install lipsum pgf koma-script xcolor
CMD execute_tests
