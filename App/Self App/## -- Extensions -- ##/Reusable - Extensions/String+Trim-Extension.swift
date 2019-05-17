import UIKit

extension String {
    func trim() -> String {
        guard self.count > 1 else { return self }
        let string = self.replacingOccurrences(of: "  ", with: " ")
        /// Swift 5 only function
//        if string.first!.isWhitespace {
        
        /// Swift 4.2 function
        if string.first! == "\u{0009}" || string.first! == "\u{0020}" || string.first! == "\u{2029}" || string.first! == "\u{3000}" {
            return String(self.dropFirst())
        } else {
            return string
        }
//        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
