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
        parentID: Category.IDValue?
    ) {
        self.name = name
        self.$parent.id = parentID
    }
}
