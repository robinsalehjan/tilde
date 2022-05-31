import Fluent

struct CreateCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Category.schema)
            .id()
            .field("name", .string, .required)
            .field("parent_id", .uuid, .references("categories", "id"))
            .unique(on: "name", name: "no_duplicate_names")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Category.schema).delete()
    }
}
