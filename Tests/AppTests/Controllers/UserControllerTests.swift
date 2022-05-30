@testable import App
import XCTVapor

final class UserControllerTests: XCTestCase {
    var app = Application(.testing)
    let database = MockDatabaseService()

    func testCreateUser() throws {
        try? configure(app, database: database)

        try app.test(.POST, "create/user", beforeRequest: { request in
            let user = User(username: "test", firstName: "test", lastName: "tester")
            try request.content.encode(user)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })
    }
}
