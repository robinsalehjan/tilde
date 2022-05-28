import Fluent
import Vapor

final class Listing: Model, Content {
    struct Input: Content {
        let title: String
        let caption: String?
        let category: String
        let likes: Int
        let size: String
        let currency: String
        let askingPrice: Int
        let isSold: Bool
    }

    struct Output: Content {
        let listingNumber: Int?
        let owner: User
        let title: String
        let caption: String?
        let category: String
        let likes: Int
        let size: String
        let currency: String
        let askingPrice: Int
        let isSold: Bool
        let createdAt: String?
    }

    struct Error: Content {
        let error: [String: String]
    }

    static let schema = "listings"

    @ID var id: UUID?

    @OptionalField(key: "listing_number") var listingNumber: Int?

    @Field(key: "title") var title: String

    @OptionalField(key: "caption") var caption: String?

    @Field(key: "category") var category: String

    @Field(key: "likes") var likes: Int

    @Field(key: "size") var size: String

    @Field(key: "currency") var currency: String

    @Field(key: "asking_price") var askingPrice: Int

    @Field(key: "is_sold") var isSold: Bool

    @Timestamp(key: "created_at", on: .create, format: .iso8601) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update, format: .iso8601) var updatedAt: Date?

    @Parent(key: "owner_id") var ownerID: User

    public init() {}

    public init(
        title: String,
        caption: String? = nil,
        category: String,
        likes: Int,
        size: String,
        currency: String,
        askingPrice: Int,
        isSold: Bool,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        ownerID: User.IDValue
    ) {
        self.title = title
        self.category = category
        self.caption = caption
        self.likes = likes
        self.size = size
        self.currency = currency
        self.askingPrice = askingPrice
        self.isSold = isSold
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.$ownerID.id = ownerID
    }
}

extension Listing {
    static func exists(
        _ ownerID: UUID,
        database: Database
    ) async -> Bool {
        let listing = try? await Listing.query(on: database)
            .filter(\.$id == ownerID)
            .first()
        return listing != nil ? true : false
    }

    static func fetch(
        _ ownerID: UUID,
        database: Database
    ) async -> Listing? {
        return try? await Listing.query(on: database)
            .filter(\.$id == ownerID)
            .first()
    }

    static func fetch(
        _ listingNumber: Int,
        database: Database
    ) async -> Listing? {
        return try? await Listing.query(on: database)
            .filter(\.$listingNumber == listingNumber)
            .first()
    }
}
