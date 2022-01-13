FROM bitnami/minideb:bullseye AS setup

RUN install_packages curl ca-certificates

WORKDIR /tmp/vitalam-node/

RUN curl -L https://github.com/gruntwork-io/fetch/releases/download/v0.4.2/fetch_linux_amd64 --output ./fetch && chmod +x ./fetch

ARG VITALAM_VERSION=latest

RUN ./fetch --repo="https://github.com/digicatapult/vitalam-node" --tag="${VITALAM_VERSION}" --release-asset="vitalam-node-.*-x86_64-unknown-linux-gnu.tar.gz" ./ \
  && tar -xzf ./vitalam-node-*-x86_64-unknown-linux-gnu.tar.gz 

FROM bitnami/minideb:bullseye AS runtime

RUN install_packages libgcc-10-dev

RUN mkdir /vitalam-node /data

COPY --from=setup /tmp/vitalam-node /vitalam-node/

WORKDIR /vitalam-node

CMD /vitalam-node/vitalam-node

EXPOSE 30333 9933 9944

# #docker run -it --rm -h node-0 -e IDENTITY=dev -e WS=true -p 30333:30333 -p 9944:9944 -p 9933:9933 vitalam-substrate-node ./run.sh
