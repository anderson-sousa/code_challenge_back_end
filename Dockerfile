FROM elixir:1.8.1

RUN apt-get update && \
  apt-get install -y postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

EXPOSE 4000

RUN mix local.hex --force

# Compile the project
RUN mix do compile

CMD ["/app/entrypoint.sh"]