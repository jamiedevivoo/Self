import UIKit

protocol ViewBuilding {
    func setupChildViews()
}

protocol ViewIsDependantOnAccountData { }
extension ViewIsDependantOnAccountData {
    var accountRef: Account {
        return AccountManager.shared().accountRef!
    }
}

protocol DictionaryConvertable {
    var dictionary: [String: Any] { get }
}

protocol TextInputs: class {
    
}
