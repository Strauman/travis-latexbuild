ARG scheme
FROM strauman/tex:tl-$scheme
RUN tlmgr install lipsum pgf koma-script xcolor

RUN mkdir /repo/
WORKDIR /repo

RUN apk-install vim git

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
