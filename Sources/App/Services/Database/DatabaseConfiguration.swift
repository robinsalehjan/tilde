public protocol DatabaseConfiguration {
    var hostname: String { get set }
    var port: Int { get set }
    var username: String { get set }
    var password: String { get set }
    var databaseName: String { get set }

    init(hostname: String, port: Int, username: String, password: String, databaseName: String)
}
