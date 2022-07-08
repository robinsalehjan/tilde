# Prequisite
- We will use [homebrew](https://brew.sh) to install Docker.


# Run via Docker

1. Install
```
brew install docker
```

2. Create `.env` file with the content:

```
SERVICE_NAME=tilde_app
SERVICE_PORT=8080
DATABASE_NAME=tilde_database
DATABASE_USERNAME=tilde_username
DATABASE_PASSWORD=tilde_password
DATABASE_PORT=5432
```

2. Build image and start containers
                                     
```
docker build --no-cache .
docker compose up --force-recreate
```

# Is it running?

If everything went smoothly you should be greeted with this in the terminal :)
```
[+] Running 2/0
 ⠿ Container tilde_database  Created                                                                                                                       0.0s
 ⠿ Container tilde_app       Created                                                                                                                       0.0s
Attaching to tilde_app, tilde_database
...
tilde_app       | [ NOTICE ] Server starting on http://tilde_app:8080
```

Or create a user by running curl:
```
curl --location --request POST 'localhost:8080/create/user' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=username' \
--data-urlencode 'firstName=user' \
--data-urlencode 'lastName=name'
```

# Would I do it again?

Swift is known for begin notoriously bad at working with JSON and I felt that while developing this. Overriding the global encoding and decoding configuration does not produce the results that I expected, changing `snake-case` to `CamelCase` in requests and `CamelCase` to `snake-case` for responses. 

[See configuration options passed to `App` instance here](https://github.com/robinsalehjan/tilde/blob/29097370be9a0cac81a3798068cf4dbf5ac447e8/Sources/App/configure.swift#L7-L19)

The heavy usage of `KeyPath` in the APIs is great for developer productivity, but the downside is that compiler will not always be able to infer the expression. This issue was **extremely** prelevant when working with the query builder provided by `Fluent` framework. This resulted in a numerous of `Failed to produce diagnostics for expression, please submit a bug report to Apple` in Xcode.

I would use `Vapor` for internal microservices, or only use `Vapor` and not the `Fluent` ORM framework, most of these painpoints will improve as the ecosystem around `Vapor` and `Swift` grows.
