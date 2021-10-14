FROM openjdk:8-jre-alpine3.9

COPY target/spring-petclinic-2.5.0-SNAPSHOT.jar /usr/bin/spring-petclinic.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "/usr/bin/spring-petclinic.jar", "--server.port=80"]