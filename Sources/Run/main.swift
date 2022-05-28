import Vapor
import FluentPostgresDriver
import App

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let hostname = Environment.get("DATABASE_HOST")!
let port = Environment.get("DATABASE_PORT").flatMap({Int($0)})!
let username = Environment.get("DATABASE_USERNAME")!
let password = Environment.get("DATABASE_PASSWORD")!
let databaseName = Environment.get("DATABASE_NAME")!

let database = PostgresService(
    hostname: hostname,
    port: port,
    username: username,
    password: password,
    databaseName: databaseName
)

let app = Application(env)
defer { app.shutdown() }

app.logger.info("Configuring application")

try configure(app, database: database)
try app.run()
