FROM centos:7.3.1611
MAINTAINER Gabriel Malet <gmalet@galilee.fr>

ENV INSTALL_HOME /opt/cs

ENV GRADLE_VERSION 3.5
ENV GRADLE_USER_HOME /opt/cs/cache

ENV JAVA_HOME /usr/java/latest
ENV JAVA_VERSION 8u131
ENV BUILD_VERSION b11
ENV CHECKSUM_VERSION d54c1d3a095b4ff2b6607d096fa80163

WORKDIR ${INSTALL_HOME}

# Install requires
RUN yum -y install wget curl bash unzip git openssh

# Install JAVA
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-${BUILD_VERSION}/${CHECKSUM_VERSION}/jdk-${JAVA_VERSION}-linux-x64.rpm \
        -O /tmp/jdk8.rpm \
    && yum -y install /tmp/jdk8.rpm \
    && rm -f /tmp/jdk8.rpm \
    && java -version

# Install Gradle
RUN wget --no-cookies --no-check-certificate \
        https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
        -O /tmp/gradle.zip \
    && mkdir /opt/gradle \
    && unzip -d /opt/gradle /tmp/gradle.zip \
    && rm -rf /tmp/gradle.zip \
    && ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle \
    && gradle -v

# Install NodeJS (for NPM)
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \
    && yum -y install nodejs

# Install Yarn
RUN wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo \
    && yum -y install yarn


COPY resources/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]