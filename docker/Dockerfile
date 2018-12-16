ARG scheme
FROM strauman/tex:tl-$scheme

RUN mkdir /repo/
WORKDIR /repo

# Python is required by texliveonfly
RUN apk-install python

RUN apk-install vim git

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
