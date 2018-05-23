# phoenix-s2i-builder
FROM openshift/base-centos7

LABEL maintainer="Sergio Ocón 'chargio' <sergio.ocon@gmail.com>"

ENV BUILDER_VERSION 1.3

ARG ERLANG_VERSION=20.3
ARG ELIXIR_VERSION=1.6.5
ARG NODE_VERSION=8
ARG ENVIRONMENT=prod

ENV ERLANG_VERSION ${ERLANG_VERSION}
ENV ELIXIR_VERSION ${ELIXIR_VERSION}
ENV NODE_VERSION ${NODE_VERSION}
ENV MIX_ENV  ${ENVIRONMENT}

LABEL io.k8s.description="Platform for building and running a phoenix app on Openshift" \
      io.k8s.display-name="s2i-phoenix-builder" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"


# TODO: Install required packages here:
# yum update to make sure that all packages are in the latest version
RUN set -x && yum update -y && yum clean all -y

# Make sure that the locale is UTF-8 and make it available in the image

RUN set -x && yum reinstall glibc-common -y
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN locale -a

ENV LANG en_US.utf8
ENV LC_CTYPE en_US.utf8
ENV LC_ALL=

# Install ERLANG
RUN set -x \
  && yum install -y --setopt=tsflags=nodocs \
    epel-release \
  && rpm -ivh https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm \
  && yum install -y --setopt=tsflags=nodocs \
    erlang-${ERLANG_VERSION} \
   && yum clean all -y

#Install ELIXIR
RUN set -x \
  && wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip \
  && unzip -d /opt/app-root -x Precompiled.zip \
  && rm -f Precompiled.zip

# Install node/npm
# Install yarn
RUN set -x \
   && curl -sL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - \
   && curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
   && yum install yarn -y \
   && yum clean all -y

# TODO: Install build tools 
# RUN set -x \
# && yum install gcc-c++ make

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 4000

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]

