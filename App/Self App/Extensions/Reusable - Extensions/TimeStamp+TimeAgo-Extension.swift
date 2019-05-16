import UIKit

extension Date {
    func formatTimeAgoFrom() -> String {
        let date = self
        let dateformatter = DateFormatter()
        
        switch abs(date.timeIntervalSinceNow / 86400) {
        case ...1:
            dateformatter.dateFormat = "h:mm a"
            return "Today, \(dateformatter.string(from: self))"
        case 1...2:
            dateformatter.dateFormat = "h:mm a"
            return "Yesterday, \(dateformatter.string(from: self))"
        case 2...7:
            dateformatter.dateFormat = "EEEE, h:mm a"
            return dateformatter.string(from: self)
        case 7...14:
            dateformatter.dateFormat = "EEEE, h:mm a"
            return "Last \(dateformatter.string(from: self))"
        default:
            dateformatter.dateFormat = "dd MMM - h:mm a"
            return dateformatter.string(from: self)
        }
    }
}
