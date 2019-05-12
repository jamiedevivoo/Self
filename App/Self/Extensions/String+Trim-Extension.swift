import UIKit

extension String {
    func trim() -> String {
        guard self.count > 1 else { return self }
        let string = self.replacingOccurrences(of: "  ", with: " ")
        if string.first!.isWhitespace {
            return String(self.dropFirst())
        } else {
            return string
        }
//        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
