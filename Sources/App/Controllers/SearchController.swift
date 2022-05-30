import Vapor

public struct SearchController: RouteCollection {
    public func boot(routes: RoutesBuilder) throws {
        routes.group("search") { router in
            router.get(use: search)
        }

        routes.group("listing") { router in
            router.get(use: searchForListing)
        }
    }
}

extension SearchController {
    func search(request: Request) async throws -> Response {
        let database = request.db

        do {
            return try await Listing.query(on: database)
                .limit(32)
                .all()
                .encodeResponse(status: .ok, for: request)
        } catch {
            request.logger.error("Failed to handle request: \(request)")
            return Response.create(status: .internalServerError, mediaType: .json)
        }
    }

    func searchForListing(request: Request) async throws -> Response {
        let database = request.db

        guard let listingNumber = request.query[Int.self, at: "listingNumber"] else {
            request.logger.info("Missing listingId as query parameter")
            return Response.create(status: .badRequest, mediaType: .json)
        }

        if let listing = await Listing.fetch(listingNumber, database: database) {
            return try await listing.encodeResponse(for: request)
        } else {
            return Response.create(status: .notFound, mediaType: .json)
        }
    }
}
