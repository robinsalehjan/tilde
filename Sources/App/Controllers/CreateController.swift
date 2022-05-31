import Vapor

public struct CreateController: RouteCollection {
    public func boot(routes: RoutesBuilder) throws {
        routes.group("create") { router in
            router.post("user", use: createUser)
        }
    }
}

extension CreateController {
    func createUser(request: Request) async throws -> Response {
        let database = request.db

        do {
            let input = try request.content.decode(User.Input.self)
            let user = CreateUserFactory.createUser(input)

            let userAlreadyExists = await User.exists(user.username, database: database)

            if userAlreadyExists {
                request.logger.error("user with username: \(user.username) already exists")
                return Response.create(status: .conflict, mediaType: .json)
            } else {
                try await user.create(on: database)
                return Response.create(status: .ok, mediaType: .json)
            }
        } catch let error {
            request.logger.error("Failed to handle request: \(request) with error: \(error)")
            return Response.create(status: .internalServerError, mediaType: .json)
        }
    }
}
