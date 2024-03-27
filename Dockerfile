FROM centos:7


# Tomcat and Java Vars
ENV JDK_MAJOR_VERSION=8u131 \
    JDK_VERSION=1.8.0_131 \
    TOMCAT_MAJOR_VERSION=8 \
    TOMCAT_VERSION=8.5.100 \
    JAVA_HOME=/opt/java \
    CATALINA_HOME=/opt/tomcat \
    PATH=$PATH:$JAVA_HOME/bin:${CATALINA_HOME}/bin:${CATALINA_HOME}/scripts \
    JAVA_OPTS="-Xms512m -Xmx2048m"

# Update and install latest packages and prerequisites
RUN yum -y update && yum clean all && yum -y install wget

# Install Oracle JDK and Tomcat
RUN echo "Installing Java JDK ${JDK_VERSION}..." && \
    cd /opt && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz \
    -O /opt/jdk-8u131-linux-x64.tar.gz && \
    tar xf /opt/jdk-8u131-linux-x64.tar.gz && \
    rm jdk-8u131-linux-x64.tar.gz && \
    mv jdk${JDK_VERSION} ${JAVA_HOME} && \
    echo "Installing Tomcat ${TOMCAT_VERSION}..." && \
    wget -nv http://apache.mirror.gtcomm.net/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    -O /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar xf /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm  apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    chmod +x ${CATALINA_HOME}/bin/*sh

#----------------------------------Create /opt/software folder for addinitonal soft needed by Tomcat ------------------------------
RUN mkdir /opt/software

#Donwload and install open ssl 
RUN wget https://www.openssl.org/source/openssl-3.0.13.tar.gz
RUN tar -xvf openssl-3.0.13.tar.gz
RUN mv openssl-3.0.13 openssl
RUN mv openssl /opt/software/openssl


# Tomcat scripts setup and sample.war
ADD sample.war ${CATALINA_HOME}/webapps/
COPY conf/server.xml ${CATALINA_HOME}/conf/server.xml
ADD conf/cert.pem ${CATALINA_HOME}/conf/
ADD conf/key.pem ${CATALINA_HOME}/conf/
COPY scripts/ ${CATALINA_HOME}/scripts/
RUN chmod +x ${CATALINA_HOME}/scripts/*.sh

# Expose and Start Services
WORKDIR ${CATALINA_HOME}
EXPOSE 4016 
CMD ["/opt/tomcat/scripts/tomcat.sh"]
