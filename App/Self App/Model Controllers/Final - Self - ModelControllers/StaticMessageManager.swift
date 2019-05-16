import SwiftyJSON
// swiftlint:disable force_try

final class StaticMessages {
    static let get: JSON = {
        let staticDataFile = Bundle.main.path(forResource: "OfflineStaticData", ofType: "json")!
        return try! JSON(data: NSData(contentsOfFile: staticDataFile)! as Data)
    }()
}
