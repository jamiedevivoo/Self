class App {
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(User)
    }
    
    var state: State = .unregistered
}
