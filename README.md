# Code Challenge Back-End

## Installing locally

To run this project, you will need to install the following dependencies on your system:

| Dependencie |Version       |
| :---------: | :---------:  |
| [Elixir](https://elixir-lang.org/install.html)| 1.8.1 |
| [Phoenix](https://hexdocs.pm/phoenix/installation.html)| 1.4.0 |
| [PostgreSQL](https://www.postgresql.org/download/)| 10.6 |

### Setting up and running

To get started, run the following commands in your project folder:

```shell
sudo apt-get install postgis # install postgis
mix deps.get  # installs the dependencies
mix ecto.setup  # creates the database and run migrations
iex -S mix phx.server  # run the application
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker

Before execute this commands make sure that [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/install/) are installed and running.

```shell
docker-compose build && docker-compose up
```

## Test

To execute the test suits locally:

```shell
mix test
```

## API documentation

You can use the content of api.yml to see the docs on [Swagger Editor](https://editor.swagger.io/?_ga=2.120330568.1739590788.1554839529-1342984360.1550614872).

## Deploy

After clone this project to the server and define the environment variables(SECRET, PGUSER,PGPASSWORD,PGDATABASE), run the following commands:

```shell
cp ./config/prod.secret.exs.sample ./config/prod.secret.exs
mix deps.get --only prod
MIX_ENV=prod elixir --detached -S mix do compile, phx.server
```