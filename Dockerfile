FROM maven:3-jdk-8 as build

ADD pom.xml /opt
#ADD mule-artifact.json /opt
ADD src /opt/src

WORKDIR /opt
RUN mvn package
RUN cp ./target/hello-*.zip hello.zip

FROM openjdk:8u171-jdk

ENV MULE_HOME /opt/mule
ENV TZ America/Sao_Paulo
#ENV MULE_VERSION=3.8.1
ENV MULE_VERSION=3.9.0

RUN mkdir -p /opt && \
    wget -q https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/$MULE_VERSION/mule-standalone-$MULE_VERSION.tar.gz && \
    tar -xf mule-standalone-$MULE_VERSION.tar.gz && \
    mv mule-standalone-$MULE_VERSION /opt && \
    mv /opt/mule-standalone-$MULE_VERSION /opt/mule

COPY --from=build /opt/hello.zip ${MULE_HOME}/apps
COPY src/main/domain/mule-* ${MULE_HOME}/domains/default/

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Define working directory.
WORKDIR ${MULE_HOME}

 #"hello" endpoint
EXPOSE 8081

HEALTHCHECK CMD curl --fail http://localhost:8081/hello || exit 1 

CMD /opt/mule/bin/mule
