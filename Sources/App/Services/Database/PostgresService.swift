public final class PostgresService: DatabaseConfiguration {
    public var hostname: String
    public var port: Int
    public var username: String
    public var password: String
    public var databaseName: String

    public init(
        hostname: String,
        port: Int,
        username: String,
        password: String,
        databaseName: String
    ) {
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        self.databaseName = databaseName
    }
}
