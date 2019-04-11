class AccountSettings {
    var flags: AccountFlags = AccountFlags()
    var notifications: AccountNotificationConsents = AccountNotificationConsents()
    var userColorMode: UserColorMode = .auto
}

extension AccountSettings {
    enum UserColorMode {
        case light
        case dark
        case auto
    }
}
