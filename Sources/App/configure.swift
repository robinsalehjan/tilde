import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    try routes(app)
}

public func configure(_ app: Application, database: DatabaseConfiguration) throws {

    app.logger.info("Connecting to database with configuration: \(database)")

    app.databases.use(
        .postgres(
            hostname: database.hostname,
            port: database.port,
            username: database.username,
            password: database.password,
            database: database.databaseName
        ),
        as: .psql
    )

    app.logger.info("Attempting to perform database migrations")

    do {
        try app.autoMigrate().wait()
    } catch {
        try app.autoRevert().wait()
    }

    app.logger.info("Attempting to register routes")

    try routes(app)
}
