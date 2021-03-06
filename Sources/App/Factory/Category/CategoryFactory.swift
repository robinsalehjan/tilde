import Foundation
import protocol FluentKit.Database

protocol CategoryFactory {
    static func createCateogry(_ input: Category.Input, parentID: Category.IDValue?) -> Category
    static func createCategoryFromInput(_ string: String, to database: Database) async -> Category?
}
