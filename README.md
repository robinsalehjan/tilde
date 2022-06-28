# Prequisite
- We will use [homebrew](https://brew.sh) to install dependencies and it's required for the step-by-step tutorial below.


# Run via Docker

1. Install
```
brew install docker
```

2. Create a `.env` file that contains:

```
APP_HOSTNAME="tilde_app"
APP_PORT="8080"
DATABASE_PORT="5432"
DATABASE_HOSTNAME="tilde_database"
DATABASE_USERNAME="tilde_username"
DATABASE_PASSWORD="tilde_password"
DATABASE_NAME="tilde_database"
```

2. Start `Docker`
                                     
```
docker compose build && docker compose up
```

# Run locally

1. Add these environment variables to your shell session:

```
export APP_HOSTNAME=tilde_app
export APP_PORT=8080
export DATABASE_PORT=5432
export DATABASE_HOSTNAME=tilde_database
export DATABASE_USERNAME=tilde_username
export DATABASE_PASSWORD=tilde_password
export DATABASE_NAME=tilde_database
```

2. Install `PostgreSQL`

```
brew install postgresql 
brew services start postgresql
```

3. Create user and database via `psql`

```
CREATE DATABASE tilde_database;
CREATE USER youruser WITH PASSWORD 'tilde_password';
GRANT ALL PRIVILEGES ON DATABASE tilde_database TO tilde_username;
```

4. Install `Vapor`
```
brew install vapor
vapor run
```

# Is it running?

If everything went smoothly you should be greeted with this in the terminal or Xcode output console :)
```
[ INFO ] Connecting to database with configuration: App.PostgresService
[ INFO ] Attempting to perform database migrations
[ INFO ] Attempting to register routes
[ INFO ] Successfully registered routes: [POST /create/user, POST /user/create/listing, GET /user/read/listings, POST /user/update/listing/like, GET /search]
[ NOTICE ] Server starting on http://127.0.0.1:8080
```

# Would I do it again?

Swift is known for begin notoriously bad at working with JSON and I felt that while developing this. Heck even overriding the global encoding and decoding configuration does not produce the results that I expected => change from `snake-case` to `CamelCase` in requests and inverse for responses.

The heavy usage of `KeyPath` in the APIs is great for developer productivity, but the downside is that compiler will not always be able to infer the expression. This issue was **extremely** prelevant when working with the query builder provided by the `Fluent` framework. This resulted in a numerous of `Failed to produce diagnostics for expression, please submit a bug report to Apple` in Xcode.

I would maybe use it for internal microservices, or only use Vapor and not the `Fluent` ORM framework. It was a pandora's box of compiler issues both locally and when running with docker. I think that most of these painpoints will improve as the ecosystem around Vapor and Swift grows.
