FROM maven as build

RUN mkdir -p /opt/default/src
ADD src/main/domain/src /opt/default/src
ADD src/main/domain/mule-project.xml /opt/default/
ADD src/main/domain/pom.xml /opt/default/



WORKDIR /opt/default 

RUN mvn package --debug
RUN mv ./target/mule-domain-*.jar ./target/default.jar
RUN ls /opt/default/target 
#RUN mv ./target/*.jar  

RUN mkdir -p /opt/hello/src/main/mule
ADD src/main/mule /opt/hello/src/main/mule
ADD src/main/mule/mule-artifact.json /opt/hello/
ADD src/main/mule/pom.xml /opt/hello/

WORKDIR /opt/hello
RUN mvn package
RUN mv ./target/say-hello-*.jar ./target/say-hello.jar


FROM openjdk:8u171-jdk

ENV MULE_HOME /opt/mule
ENV TZ America/Sao_Paulo

RUN wget -q https://s3-sa-east-1.amazonaws.com/it-util/sfw/Mulesoft/mule-standalone-4.1.1.tar.gz && \
    tar -xf mule-standalone-4.1.1.tar.gz && \
    mv mule-standalone-4.1.1 /opt/mule

COPY --from=build /opt/default/target/*.jar ${MULE_HOME}/domains
#RUN ls /opt/hello/target
COPY --from=build /opt/hello/target/say-hello.jar ${MULE_HOME}/apps

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/defaults"]

# Define working directory.
WORKDIR ${MULE_HOME}

# "say-hello" endpoint
EXPOSE 8081

HEALTHCHECK CMD curl --fail http://localhost:8081/hello || exit 1 

CMD /opt/mule/bin/mule
