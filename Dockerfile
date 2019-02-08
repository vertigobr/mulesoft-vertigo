FROM maven as build

RUN mkdir -p /opt/domain/src
ADD src/main/domain/src /opt/domain/src
ADD src/main/domain/mule-project.xml /opt/domain/
ADD src/main/domain/pom.xml /opt/domain/



WORKDIR /opt/domain 

RUN mvn package --debug
#RUN mv ./target/*.jar 


#WORKDIR /opt
#RUN mvn package
#RUN cp ./target/say-hello-*.jar say-hello.jar


FROM openjdk:8u171-jdk

ENV MULE_HOME /opt/mule
ENV TZ America/Sao_Paulo

RUN mkdir -p /opt && \
    wget -q https://s3-sa-east-1.amazonaws.com/it-util/sfw/Mulesoft/mule-standalone-4.1.1.tar.gz && \
    tar -xf mule-standalone-4.1.1.tar.gz && \
    mv mule-standalone-4.1.1 /opt && \
    mv /opt/mule-standalone-4.1.1 /opt/mule

COPY --from=build ./target/*.jar ${MULE_HOME}/domains
#COPY --from=build /opt/say-hello.jar ${MULE_HOME}/apps

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Define working directory.
WORKDIR ${MULE_HOME}

# "say-hello" endpoint
#EXPOSE 8081

#HEALTHCHECK CMD curl --fail http://localhost:8081/hello || exit 1 

#CMD /opt/mule/bin/mule
