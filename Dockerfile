FROM ubuntu:trusty-20181115

RUN groupadd -g 1117 tdr && useradd -u 1117 -g tdr -m tdr && \
    mkdir -p /etc/canadiana /var/log/tdr /var/lock/tdr && ln -s /home/tdr /etc/canadiana/tdr && chown tdr.tdr /var/log/tdr /var/lock/tdr && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq cpanminus build-essential libxml-libxml-perl libxml-libxslt-perl libio-aio-perl rsync && apt-get clean

WORKDIR /home/tdr
COPY cpanfile* *.conf /home/tdr/
ENV PERL_CPANM_OPT "--mirror http://pinto.c7a.ca/stacks/c7a-perl-devel/ --mirror http://www.cpan.org/"
RUN cpanm -n --installdeps . && rm -rf /root/.cpanm || (cat /root/.cpanm/work/*/build.log && exit 1)

#RUN curl -OL http://pinto.c7a.ca/deploy/CIHM-TDR-0.12.tar.gz &&  cpanm CIHM-TDR-0.12.tar.gz

USER tdr
