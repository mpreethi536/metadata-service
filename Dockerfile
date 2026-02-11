FROM alpine:3.19

# build-time inputs from Jenkins
ARG BUILD_NUMBER
ARG APP_NAME

WORKDIR /app

# artifact created by Jenkins
COPY metadata-service-*.tar.gz /app/

RUN for f in metadata-service-*.tar.gz; do \
      tar -xzf "$f"; \
      rm "$f"; \
    done

LABEL app.name=$APP_NAME
LABEL build.number=$BUILD_NUMBER

CMD ["sh"]
