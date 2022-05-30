import Fluent
import Vapor

public func routes(_ app: Application) throws {
    try app.register(collection: CreateController())
    try app.register(collection: UserController())
    try app.register(collection: SearchController())
    app.logger.info("Successfully registered routes: \(app.routes.all.description)")
}
