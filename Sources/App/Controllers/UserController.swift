import Vapor
import FluentKit

public struct UserController: RouteCollection {
    public func boot(routes: RoutesBuilder) throws {
        routes.group("user") { router in
            router.post("create", "listing", use: createListing)

            router.get("read", "listings", use: fetchListings)

            router.post("update", "listing", "like", use: likeListing)
        }
    }
}

// MARK: - Create

extension UserController {
    func createListing(request: Request) async throws -> Response {
        let database = request.db

        guard let username = request.query[String.self, at: "username"] else {
            request.logger.info("Missing username as query parameter")
            return Response.create(status: .badRequest, mediaType: .json)
        }

        guard let user = await User.fetch(username, database: database) else {
            request.logger.info("User with username: \(username) does not exist")
            return Response.create(status: .forbidden, mediaType: .json)
        }

        do {
            let userID = try user.requireID()
            let input = try request.content.decode(Listing.Input.self)

            if let category = await CreateCategoryFactory.createCategoryFromString(input.category, to: database) {
                let categoryID = try? category.requireID()

                let listing = CreateListingFactory.createListing(input, ownerID: userID, categoryID: categoryID)
                try? await listing.create(on: database)

                let output = CreateListingFactory.createListingOutput(listing)
                return try await output.encodeResponse(status: .ok, for: request)

            } else {
                request.logger.error("Category \(input.category) is not supported")
                return Response.create(status: .ok, mediaType: .json)
            }

        } catch let error {
            request.logger.error("Failed to handle request: \(request) with error: \(error)")
            return Response.create(status: .internalServerError, mediaType: .json)
        }
    }
}

// MARK: - Read

extension UserController {
    func fetchListings(request: Request) async throws -> Response {
        let database = request.db

        guard let username = request.query[String.self, at: "username"] else {
            request.logger.info("Missing username as query parameter")
            return Response.create(status: .badRequest, mediaType: .json)
        }

        let userExists = await User.exists(username, database: database)
        guard userExists else {
            request.logger.error("user with username: \(username) does not exist")
            return Response.create(status: .badRequest, mediaType: .json)
        }

        do {
            let data = try await Listing.query(on: database)
                .join(User.self, on: \Listing.$ownerID.$id == \User.$id)
                .filter(User.self, \.$username == username)
                .all()

            if data.isEmpty {
                return Response.create(status: .noContent, mediaType: .json)
            } else {
                return try await data.encodeResponse(status: .ok, for: request)
            }

        } catch let error {
            request.logger.info("Failed to fetch all listings for: \(username) with error: \(error)")
            return Response.create(status: .internalServerError, mediaType: .json)
        }
    }
}

// MARK: - Update

extension UserController {
    func likeListing(request: Request) async throws -> Response {
        let database = request.db

        guard let listingNumber = request.query[Int.self, at: "listingNumber"] else {
            request.logger.info("Missing listingNumber as query parameter")
            return Response.create(status: .badRequest, mediaType: .json)
        }

        guard let listing = await Listing.fetch(listingNumber, database: database) else {
            request.logger.info("Listing with listingNumber: \(listingNumber) does not exist")
            return Response.create(status: .notFound, mediaType: .json)
        }

        do {
            let currentNumberOfLikes = listing.likes
            listing.likes = currentNumberOfLikes + 1
            try await listing.save(on: database)

            let output = CreateListingFactory.createListingOutput(listing)
            return try await output.encodeResponse(status: .ok, for: request)
        } catch let error {
            request.logger.error("Failed to save like count for listing number: \(listingNumber) with error: \(error)")
            return Response.create(status: .ok, mediaType: .json)
        }
    }
}
