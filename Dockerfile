FROM eclipse-temurin:11-jre

ARG BUILD_NUMBER

WORKDIR /app

COPY target/metadata-service.jar app.jar

LABEL build.number=$BUILD_NUMBER

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
