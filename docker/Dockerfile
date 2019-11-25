ARG scheme
FROM strauman/tex:tl-${scheme}-2019

RUN mkdir /repo/
WORKDIR /repo

# Python is required by texliveonfly
RUN apk add --no-cache --update python3
# Put it in path as python instead of python3
RUN ln -s /usr/bin/python3 /usr/bin/python
# Install texliveonfly to download package dependencies automatically
RUN tlmgr update --self
RUN tlmgr install texliveonfly

RUN apk add --no-cache vim git

COPY execute_tests.sh "/usr/bin/execute_tests"

RUN chmod +x "/usr/bin/execute_tests"

CMD execute_tests
