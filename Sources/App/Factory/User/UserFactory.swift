protocol UserFactory {
    static func createUser(_ input: User.Input) -> User
    static func createUserOutput(_ model: User) -> User.Output
}
