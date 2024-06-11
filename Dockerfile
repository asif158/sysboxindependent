FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

COPY peers.dat /tmp

COPY backend-flo-testnet_0.15.1.1-satoshilabs-1_amd64.deb /tmp/backend-flo.deb

RUN apt-get update && \
    apt-get install -y /tmp/backend-flo.deb && \
    rm /tmp/backend-flo.deb

RUN cd /opt/coins/nodes/flo_testnet && \
	/opt/coins/nodes/flo_testnet/bin/flod --testnet -datadir=/opt/coins/data/flo_testnet/backend -conf=/opt/coins/nodes/flo_testnet/flo_testnet.conf -pid=/run/flo_testnet/flo_testnet.pid
    
COPY blockbook-flo-testnet_0.4.0_amd64.deb /tmp/blockbook-flo.deb
    
RUN apt-get update && \
    apt-get install -y /tmp/blockbook-flo.deb && \
    rm /tmp/blockbook-flo.deb
# RUN cd /opt/coins/blockbook/flo_testnet && \
# 	/opt/coins/blockbook/flo_testnet/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo_testnet/config/blockchaincfg.json -datadir=/opt/coins/data/flo_testnet/blockbook/db -sync -internal=:19066 -public=:19166 -certfile=/opt/coins/blockbook/flo_testnet/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo_testnet/logs -dbcache=1073741824

RUN mv /tmp/peers.dat /opt/coins/data/flo_testnet/backend/testnet4/peers.dat
# architecture of the file
# root@c7fefb595241:/opt/coins/blockbook/flo_testnet/bin# file blockbook 
# blockbook: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=fe2626e7378eaeacdd810a61c5a0111ab68fe072, for GNU/Linux 3.2.0, stripped

EXPOSE 19166

VOLUME /opt/coins

CMD /bin/bash -c "cd /opt/coins/nodes/flo_testnet && /opt/coins/nodes/flo_testnet/bin/flod --testnet -datadir=/opt/coins/data/flo_testnet/backend -conf=/opt/coins/nodes/flo_testnet/flo_testnet.conf -pid=/run/flo_testnet/flo_testnet.pid && cd /opt/coins/blockbook/flo_testnet && /opt/coins/blockbook/flo_testnet/bin/blockbook -blockchaincfg=/opt/coins/blockbook/flo_testnet/config/blockchaincfg.json -datadir=/opt/coins/data/flo_testnet/blockbook/db -sync -internal=:19066 -public=:19166 -certfile=/opt/coins/blockbook/flo_testnet/cert/blockbook -explorer= -log_dir=/opt/coins/blockbook/flo_testnet/logs -dbcache=1073741824"

# check logs of the services
# tail -f /opt/coins/data/flo_testnet/backend/testnet4/debug.log