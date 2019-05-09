import UIKit

protocol ViewBuilding {
    func setupChildViews()
}

protocol DictionaryConvertable {
    var dictionary: [String: Any] { get }
}

protocol TextInputs: class {
    
}
