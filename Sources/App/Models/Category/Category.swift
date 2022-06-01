import Fluent
import Vapor

final class Category: Model, Content {
    struct Input: Content {
        let name: String
    }

    struct Output: Content {
        let name: String
        let parent: Category?
    }

    static let schema = "categories"

    @ID var id: UUID?

    @OptionalParent(key: "parent_id")
    var parent: Category?

    @Field(key: "name") var name: String

    init() { }

    init(
        name: String,
        parentID: Category.IDValue? = nil
    ) {
        self.name = name
        self.$parent.id = parentID
    }
}

/// Ideally this should have been modelled as a set of child categories or graph rather than a linear tree
///  This solution doesn't scale with very large trees
extension Category {
    func add(_ categories: [String], to database: Database) async -> Category {
        if categories.isEmpty {
            return self
        } else {
            var mutableList = categories

            // The new list to pass down the recursion stack
            let categoryName = mutableList.removeFirst()
            
            if let _ = await Category.fetch(categoryName, database: database) {
                // If the category already exists
                // Continue the recursion with the reduced list
                return await self.add(mutableList, to: database)
            } else {
                // Create the new category and save it to the database
                let newCategory = Category(name: categoryName, parentID: try? self.requireID())
                try? await newCategory.save(on: database)

                // Continue the recursion in order to add subcategories to this new category
                return await newCategory.add(mutableList, to: database)
            }
        }
    }
}

extension Category {
    static func exists(
        _ name: String,
        database: Database
    ) async -> Bool {
        let category = try? await Category.query(on: database)
            .filter(\.$name == name)
            .first()

        return category != nil ? true : false
    }

    static func fetch(
        _ name: String,
        database: Database
    ) async -> Category? {
        return try? await Category.query(on: database)
            .filter(\.$name == name)
            .first()
    }
}
