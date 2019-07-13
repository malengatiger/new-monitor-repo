FROM openjdk:8-jdk-alpine
VOLUME /tmp
ADD webapi-0.0.1-SNAPSHOT.jar app.jar
#RUN sh -c 'touch /app.jar'
EXPOSE 8080
ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
