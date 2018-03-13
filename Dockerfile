FROM phusion/baseimage

ARG USER_ID
ARG GROUP_ID

ENV HOME /dash

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
RUN groupadd -g ${GROUP_ID} dash
RUN useradd -u ${USER_ID} -g dash -s /bin/bash -m -d /dash dash

RUN chown dash:dash -R /dash

COPY src/dash-cli /usr/local/bin
COPY src/qt/dash-qt /usr/local/bin
COPY src/dash-tx /usr/local/bin
COPY src/dashd /usr/local/bin

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER dash

VOLUME ["/dash"]

EXPOSE 43198 43199 23798 19999

WORKDIR /dash

CMD ["dash_oneshot"]