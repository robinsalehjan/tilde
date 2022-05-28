import Fluent
import Vapor

final class User: Model, Content {
    struct Input: Content {
        let username: String
        let firstName: String
        let lastName: String
    }

    struct Output: Content {
        let username: String
        let firstName: String
        let lastName: String
    }

    static let schema = "users"

    @ID var id: UUID?

    @Field(key: "username") var username: String

    @Field(key: "first_name") var firstName: String

    @Field(key: "last_name") var lastName: String

    init() { }

    init(
        username: String,
        firstName: String,
        lastName: String
    ) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension User {
    static func exists(
        _ username: String,
        database: Database
    ) async -> Bool {
        let user = try? await User.query(on: database)
            .filter(\.$username == username)
            .first()

        return user != nil ? true : false
    }

    static func fetch(
        _ username: String,
        database: Database
    ) async -> User? {
        return try? await User.query(on: database)
            .filter(\.$username == username)
            .first()
    }
}
