FROM bitnami/minideb:buster

COPY setup /setup
RUN /setup/apt

WORKDIR /root
ARG version=master
ENV version=$DOCKER_TAG

RUN /setup/checkout

RUN /setup/build

COPY sbclrc /root/.sbclrc
RUN /usr/local/bin/sbcl --eval '(ensure-directories-exist (translate-logical-pathname #p"SYS:SITE;"))' --quit

ENTRYPOINT ["/usr/local/bin/sbcl"]
