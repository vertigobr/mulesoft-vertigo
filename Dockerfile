FROM maven as build

ADD pom.xml /opt
ADD mule-artifact.json /opt
ADD src /opt/src

WORKDIR /opt
RUN mvn package
RUN cp ./target/say-hello-*.jar say-hello.jar

FROM openjdk:8u171-jdk

#ENV MULE_HOME /opt/mule

RUN mkdir -p /opt && \
    wget https://s3-sa-east-1.amazonaws.com/it-util/sfw/Mulesoft/mule-standalone-4.1.1.tar.gz && \
    tar -xf mule-standalone-4.1.1.tar.gz && \
    mv mule-standalone-4.1.1 /opt && \
    mv /opt/mule-standalone-4.1.1 /opt/mule

COPY --from=build /opt/say-hello.jar /opt/mule/apps/
CMD /opt/mule/bin/mule
