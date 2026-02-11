FROM alpine:3.19

# build-time inputs from Jenkins
ARG BUILD_NUMBER
ARG APP_NAME

WORKDIR /app

# artifact created by Jenkins
COPY metadata-service-*.tar.gz /app/

RUN tar -xzf metadata-service-*.tar.gz && \
    rm metadata-service-*.tar.gz

LABEL app.name=$APP_NAME
LABEL build.number=$BUILD_NUMBER

CMD ["sh"]
