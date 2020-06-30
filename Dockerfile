FROM bitnami/minideb:buster AS builder

COPY setup /setup
RUN /setup/apt

WORKDIR /root
ARG version=master
ENV version=$version

RUN /setup/checkout

RUN /setup/build

FROM bitnami/minideb:buster

RUN apt-get update && apt-get install -y git make curl
COPY setup/install /root/install
COPY sbclrc /root/.sbclrc

COPY --from=builder /sbcl-build /sbcl-build
RUN /root/install

RUN /usr/local/bin/sbcl --eval '(ensure-directories-exist (translate-logical-pathname #p"SYS:SITE;"))' --quit

ENTRYPOINT ["/usr/local/bin/sbcl"]
