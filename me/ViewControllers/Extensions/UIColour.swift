import UIKit

// Note: Colours are stored as decimals (0.0 - 1.0), however RGBA values are storred as ranges from 0 to 255.
// By storing these as calculations we can view them as their RGBA values but the code will calculate them into decimals when it compiles.

extension UIColor {
    struct app {
        struct background {
            static let gray = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1)
            static let primary = UIColor(red: 255/255, green: 219/255, blue: 003/255, alpha: 1)
            static let secondary = UIColor(red: 184/255, green: 003/255, blue: 255/255, alpha: 1)
        }
        struct text {
            static let primary = UIColor(red: 010/255, green: 028/255, blue: 039/255, alpha: 1)
            static let secondary = UIColor(red: 0.2, green: 0.2, blue:0.9, alpha: 1)
        }
        struct defined {
            static let gray = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1)
            static let yellow = UIColor(red: 255/255, green: 219/255, blue: 003/255, alpha: 1)
            static let red = UIColor(red: 255/255, green: 03/255, blue: 074/255, alpha: 1)
            static let blue = UIColor(red: 003/255, green: 146/255, blue: 255/255, alpha: 1)
            static let purple = UIColor(red: 184/255, green: 003/255, blue: 255/255, alpha: 1)
            static let green = UIColor(red: 074/255, green: 255/255, blue: 003/255, alpha: 1)
        }
    }
}
