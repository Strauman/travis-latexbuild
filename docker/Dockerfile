ARG scheme
FROM strauman/tex:tl-$scheme
# Python is required by texliveonfly
#FROM python:latest
RUN apk-install python

RUN mkdir /repo/
WORKDIR /repo

RUN apk-install vim git

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
