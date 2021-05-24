FROM swipl:stable

COPY html /app/html
COPY src /app/src
WORKDIR /app

RUN echo ":- initialization(server(8080, standalone))." >>/app/src/server.pl
EXPOSE 8080
CMD ["swipl","/app/src/server.pl"]