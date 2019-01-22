From openjdk:8u171-jdk

ENV MULE_HOME: /mule-standalone-4.1.1

RUN bash -c "wget https://s3-sa-east-1.amazonaws.com/it-util/sfw/Mulesoft/mule-standalone-4.1.1.tar.gz &&  tar -xf mule-standalone-4.1.1.tar.gz"

CMD /mule-standalone-4.1.1/bin/mule