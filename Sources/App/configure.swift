import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application, database: DatabaseConfiguration) throws {

    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    // override the global encoder used for the `.json` media type
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    // override the global encoder used for the `.json` media type
    ContentConfiguration.global.use(decoder: decoder, for: .json)

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

    app.migrations.add([
        CreateUser(),
        CreateCategory(),
        CreateListing(),
    ])

    do {
        try app.autoMigrate().wait()
    } catch {
        try app.autoRevert().wait()
    }

    app.logger.info("Attempting to register routes")

    try routes(app)
}
