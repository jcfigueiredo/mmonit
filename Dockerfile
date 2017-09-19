FROM ubuntu:17.10
MAINTAINER jcfigueiredo <jcfigueiredo@gmail.com>

ENV MMONIT_VERSION mmonit-3.7.1
ENV MMONIT_USER monit
ENV MMONIT_ROOT /opt/monit
ENV MMONIT_BIN $MMONIT_ROOT/bin/mmonit
ENV MONIT_BIN /usr/bin/monit
ENV MONIT_LOG $MMONIT_ROOT/logs/monit.log
ENV MONIT_CONF $MMONIT_ROOT/conf/monitrc
ENV HOME $MMONIT_ROOT
ENV PATH $MMONIT_ROOT/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Add monit user and group
RUN groupadd -r $MMONIT_USER \
    && useradd -r -m \
       -g $MMONIT_USER \
       -d $MMONIT_ROOT \
       -s /usr/sbin/nologin \
       $MMONIT_USER

# Install mmonit and dependencies
RUN apt-get update && apt-get -y install wget tar hostname && apt-get clean

# Switch user
USER $MMONIT_USER

# Set workdir to monit root
WORKDIR $MMONIT_ROOT

# Download and install mmonit
RUN wget https://mmonit.com/dist/$MMONIT_VERSION-linux-x64.tar.gz
RUN tar -xf $MMONIT_ROOT/$MMONIT_VERSION-linux-x64.tar.gz -C /tmp/ && rm -rf $MMONIT_ROOT/$MMONIT_VERSION-linux-x64.tar.gz
RUN cp -R /tmp/$MMONIT_VERSION/* $MMONIT_ROOT/ && rm -rf /tmp/$MMONIT_VERSION

USER monit

# VOLUME ["$MMONIT_ROOT/database", "$MMONIT_ROOT/ssl"]
EXPOSE 8080

CMD ["/opt/monit/bin/mmonit", "-id"]
