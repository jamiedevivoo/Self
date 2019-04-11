import UIKit

protocol DefinedDictionaryKeys {
    var key: String { get }
//    enum Properties: String, CaseIterable
}

//protocol DictionaryConvertable where Self: DefinedDictionaryKeys  {
//    var dictionary: [String: Any] { get }
//}

protocol DictionaryConvertable {
    var dictionary: [String: Any] { get }
}
