struct AccountFlags {
    let tutorial_active: Bool = true
    let verified: Bool = false
}

extension AccountFlags: DictionaryConvertable {
    var dictionary: [String: Any] {
        return ["tutorial_active":tutorial_active,
                "verified":verified]
    }
}
