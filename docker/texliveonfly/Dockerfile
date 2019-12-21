ARG scheme
FROM strauman/tex:tl-${scheme}-2019

RUN mkdir /repo/
WORKDIR /repo

# Python is needed by texliveonfly
RUN apk add --no-cache vim git python
RUN tlmgr update --self
RUN tlmgr install texliveonfly

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
