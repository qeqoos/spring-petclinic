FROM openjdk:8-jre-alpine3.9

WORKDIR /app

COPY src ./src

COPY target/spring-petclinic-2.5.0-SNAPSHOT.jar /app/spring-petclinic.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "/app/spring-petclinic.jar", "--server.port=80"]