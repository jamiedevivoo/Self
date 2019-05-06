import UIKit

protocol UpdateAccountViews {
    var accountDependantViews: [UIView] { get }
}

protocol AccountInfoObject { }

protocol DataCollectionSequenceDelegate: class {
    func setData(_ dataDict: [String:Any?])
    func isDataCollectionComplete() -> Bool
    func finishDataCollection()
}
