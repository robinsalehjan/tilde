# Prequisite

1. Set these environment variables in your shell **or** create a `.env` file with this:

```
export DATABASE_HOST="hostname"
export DATABASE_PORT="5432"
export DATABASE_USERNAME="username"
export DATABASE_PASSWORD="password"
export DATABASE_NAME="database_name"
```

2. Install PostgreSQL

```
brew install postgresql 
brew services start postgresql
```

Remember to create the user and database via ```psql```

3. Install Docker

```
brew install docker 
```

# Run locally

This step assumes that you have Swift and Xcode installed

```
vapor run
```

# Run via Docker

Create a `.env` file that contains the environment variables from the prequisite step. This `.env` will be injected into the docker container on start-up.

```
export DATABASE_HOST="hostname"
export DATABASE_PORT="5432"
export DATABASE_USERNAME="username"
export DATABASE_PASSWORD="password"
export DATABASE_NAME="database_name"
```

Followed by
                                     
```
docker compose build && docker compose up
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

The heavy usage of `KeyPath` in the APIs is great for developer productivity, but the downside is that compiler will not always be able to infer the expression. This issue was **extremely** prelevant wwhen working with the query builder provided by the ORM `Fluent` framework. This resulted in a numerous of `Failed to produce diagnostics for expression, please submit a bug report to Apple` in Xcode.

I would maybe use it for internal microservices, or only use Vapor and not the bundled ORM framework, as it felt like a pandora's box of compiler issues locally and in docker containers.
