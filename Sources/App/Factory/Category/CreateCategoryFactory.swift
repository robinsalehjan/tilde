import protocol FluentKit.Database

class CreateCategoryFactory: CategoryFactory {
    static func createCateogry(_ input: Category.Input, parentID: Category.IDValue?) -> Category {
        return Category(name: input.name, parentID: parentID)
    }

    static func createCategoryFromString(_ string: String, to database: Database) async -> Category? {
        guard !string.isEmpty else { return nil }
        var listOfCategories = string.components(separatedBy: ".")
        let categoryName = listOfCategories.removeFirst()

        if let category = await Category.fetch(categoryName, database: database) {
            // Recurse down the reduced list
            return await category.add(listOfCategories, to: database)
        } else {
            // A new parent category
            let newCategory = Category(name: categoryName, parentID: nil)
            try? await newCategory.create(on: database)
            return newCategory
        }
    }
}
