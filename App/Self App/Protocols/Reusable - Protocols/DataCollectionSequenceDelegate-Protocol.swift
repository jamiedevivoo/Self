import UIKit

protocol UpdateAccountViews {
    var accountDependantViews: [UIView] { get }
}

protocol AccountInfoObject { }

protocol DataCollectionSequenceDelegate: class {
    func isDataCollectionComplete() -> [String: Any]?
    func finishDataCollection()
}
