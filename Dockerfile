FROM eclipse-temurin:17-jre

# build-time inputs from Jenkins
ARG BUILD_NUMBER

WORKDIR /app

# artifact created by Jenkins
COPY target/metadata-service.jar app.jar

LABEL build.number=$BUILD_NUMBER

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
