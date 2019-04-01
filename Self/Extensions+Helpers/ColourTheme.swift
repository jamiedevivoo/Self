import UIKit

extension UIColor {

    struct app {
        struct standard {
            static func background() -> UIColor {
                switch Calendar.current.component(.hour, from: Date()) {
                case 08...16:
                    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                default:
                    return UIColor(red: 029/255, green: 038/255, blue: 095/255, alpha: 1)
                }
            }
            static func other() -> UIColor {
                switch Calendar.current.component(.hour, from: Date()) {
                case 08...16:
                    return UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1)
                default:
                    return UIColor(red: 019/255, green: 025/255, blue: 083/255, alpha: 1)
                }
            }
            static func solidText() -> UIColor {
                switch Calendar.current.component(.hour, from: Date()) {
                case 08...16:
                    return UIColor(red: 010/255, green: 010/255, blue: 050/255, alpha: 1)
                default:
                    return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)
                }
            }
            static func button() -> UIColor {
                switch Calendar.current.component(.hour, from: Date()) {
                case 08...16:
                    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                default:
                    return UIColor(red: 059/255, green: 050/255, blue: 131/255, alpha: 1)
                }
            }
            static func buttonText() -> UIColor {
                switch Calendar.current.component(.hour, from: Date()) {
                case 08...16:
                    return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
                default:
                    return UIColor(red: 241/255, green: 136/255, blue: 132/255, alpha: 1)
                }
            }
//            static let background = UIColor(red: 253/255, green: 245/255, blue: 235/255, alpha: 1)

        }
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
