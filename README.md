# Prequisite
- We will use [homebrew](https://brew.sh) to install Docker.


# Run via Docker

1. Install
```
brew install docker
```

2. Create `.env` file for docker compose

```
ENV=DEVELOPMENT
SERVICE_NAME=tilde_app
SERVICE_PORT=8000
DATABASE_USERNAME=tilde_username
DATABASE_PASSWORD=tilde_password
DATABASE_NAME=tilde_database
DATABASE_PORT=5432
```

2. Build the container(s) and run the service(s)
                                     
```
make compose_build
make compose_up
```

# Is it running?

If everything went smoothly you should be greeted with this in the terminal :)
```
Attaching to tilde_app, tilde_database
tilde_database  | 
tilde_database  | PostgreSQL Database directory appears to contain a database; Skipping initialization
tilde_database  | 
tilde_database  | 2022-10-04 21:44:09.876 UTC [7] LOG:  starting PostgreSQL 14.5 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 11.2.1_git20220219) 11.2.1 20220219, 64-bit
tilde_database  | 2022-10-04 21:44:09.876 UTC [7] LOG:  listening on IPv4 address "0.0.0.0", port 5432
tilde_database  | 2022-10-04 21:44:09.876 UTC [7] LOG:  listening on IPv6 address "::", port 5432
tilde_database  | 2022-10-04 21:44:09.883 UTC [7] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
tilde_database  | 2022-10-04 21:44:09.906 UTC [23] LOG:  database system was shut down at 2022-10-04 21:36:45 UTC
tilde_database  | 2022-10-04 21:44:09.938 UTC [7] LOG:  database system is ready to accept connections
tilde_app       | [ NOTICE ] Server starting on http://tilde_app:8000
```

Alternatively create a user by running curl:
```
curl -v --location -X POST 'localhost:8000/create/user' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=username' \
--data-urlencode 'firstName=user' \
--data-urlencode 'lastName=name'
```

# Would I do it again?

Swift is known for begin notoriously bad at working with JSON. The global encoding and decoding configuration did not produce the results that I expected. 

- The encoder is configured to encode output data into `snake_case` format
  - `feeFiFoFum` => `fee_fi_fo_fum`
- The decoder is configured to decode input data into `camelCase` format
  - `base_uri` => `baseUri`

[See configuration options passed to `App` instance here](https://github.com/robinsalehjan/tilde/blob/29097370be9a0cac81a3798068cf4dbf5ac447e8/Sources/App/configure.swift#L7-L19)

The heavy usage of `KeyPath` in the APIs is great for developer productivity, but the downside is that compiler will not always be able to infer the expression. This issue was **extremely** prelevant when working with the query builder provided by `Fluent` framework. This resulted in a numerous of `Failed to produce diagnostics for expression, please submit a bug report to Apple` in Xcode.

I would use `Vapor` for internal microservices, or only use `Vapor` and not the `Fluent` ORM framework, most of these painpoints will improve as the ecosystem around `Vapor` and `Swift` grows.
