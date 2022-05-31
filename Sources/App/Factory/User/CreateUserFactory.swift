class CreateUserFactory: UserFactory {
    static func createUser(_ input: User.Input) -> User {
        return User(
            username: input.username,
            firstName: input.firstName,
            lastName: input.lastName
        )
    }

    static func createUserOutput(_ model: User) -> User.Output {
        return User.Output(
            username: model.username,
            firstName: model.firstName,
            lastName: model.lastName
        )
    }
}
