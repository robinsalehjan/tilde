import Fluent
import Vapor

public func routes(_ app: Application) throws {
    try app.register(collection: CreateController())
    try app.register(collection: UserController())
    app.logger.info("Successfully registered routes: \(app.routes.all.description)")
}
