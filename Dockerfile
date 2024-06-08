FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

COPY backend-flo_0.15.1.1-satoshilabs-1_amd64.deb /tmp/backend-flo.deb
COPY blockbook-flo_0.4.0_amd64.deb /tmp/blockbook-flo.deb

RUN apt-get update && \
    apt-get install -y /tmp/backend-flo.deb && \
    rm /tmp/backend-flo.deb
    
RUN apt-get update && \
    apt-get install -y /tmp/blockbook-flo.deb && \
    rm /tmp/blockbook-flo.deb

EXPOSE 9166

VOLUME /opt/coins

CMD /bin/bash -c "cd /opt/coins/nodes/flo && /opt/coins/nodes/flo/bin/flod -datadir=/opt/coins/data/flo/backend -conf=/opt/coins/nodes/flo/flo.conf -pid=/run/flo/flo.pid && cd /opt/coins/blockbook/flo && /opt/coins/blockbook/flo/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo/config/blockchaincfg.json -datadir=/opt/coins/data/flo/blockbook/db -sync -internal=:9066 -public=:9166 -certfile=/opt/coins/blockbook/flo/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo/logs -dbcache=1073741824"