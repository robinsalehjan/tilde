import Fluent

struct CreateListing: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Listing.schema)
            .id()
            .field("listing_number", .sql(raw: "SERIAL"), .required)
            .field("title", .string, .required)
            .field("caption", .string)
            .field("likes", .int, .required)
            .field("size", .string, .required)
            .field("currency", .string, .required)
            .field("asking_price", .int, .required)
            .field("is_sold", .bool, .required)
            .field("created_at", .string)
            .field("updated_at", .string)
            .field("owner_id", .uuid, .references(User.schema, "id"), .required)
            .field("category_id", .uuid, .references(Category.schema, "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Listing.schema).delete()
    }
}
