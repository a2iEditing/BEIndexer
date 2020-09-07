FROM biocontainers/biocontainers:latest

USER root

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/conda/bin:/home/biodocker/bin:/bin/BEIndexer/BEIndexer

RUN mkdir -pv /bin/BEIndexer && chmod 777 /bin/BEIndexer

RUN adduser --disabled-password --gecos '' aeiuser \
    && adduser aeiuser sudo \
    && echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers

WORKDIR /tmp
ADD docker_installations.sh .
RUN ./docker_installations.sh
WORKDIR /

USER aeiuser

RUN cd /bin/BEIndexer/BEIndexer && make

CMD /bin/BEIndexer/BEIndexer/BEIndexer