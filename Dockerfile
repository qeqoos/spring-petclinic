FROM openjdk:8-jre-alpine3.9

WORKDIR /app

COPY src ./src

COPY /app/target/spring-petclinic-*.jar /app/spring-petclinic.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "/app/spring-petclinic.jar", "--server.port=80"]