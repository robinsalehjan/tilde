@testable import App
import Foundation

public final class MockDatabaseService: DatabaseConfiguration {
    public var hostname: String
    public var port: Int
    public var username: String
    public var password: String
    public var databaseName: String

    public init(
        hostname: String = ProcessInfo.processInfo.environment["DATABASE_HOST"]!,
        port: Int = Int(ProcessInfo.processInfo.environment["DATABASE_PORT"]!)!,
        username: String = ProcessInfo.processInfo.environment["DATABASE_USERNAME"]!,
        password: String = ProcessInfo.processInfo.environment["DATABASE_PASSWORD"]!,
        databaseName: String = ProcessInfo.processInfo.environment["DATABASE_NAME"]!
    ) {
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        self.databaseName = databaseName
    }
}
