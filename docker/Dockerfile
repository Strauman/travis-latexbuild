ARG scheme
FROM strauman/tex:tl-${scheme}-2018


RUN mkdir /repo/
WORKDIR /repo

RUN apk add --no-cache vim git

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
