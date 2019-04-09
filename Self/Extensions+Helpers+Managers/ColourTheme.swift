import UIKit

extension UIColor {
    
    struct app {
        static func background() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 029/255, green: 038/255, blue: 095/255, alpha: 1)
            default:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
        static func other() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 019/255, green: 025/255, blue: 083/255, alpha: 1)
            default:
                return UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1)
            }
        }
        static func solidText() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)

            default:
                return UIColor(red: 010/255, green: 010/255, blue: 050/255, alpha: 1)
            }
        }
        static func button() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 059/255, green: 050/255, blue: 131/255, alpha: 1)
            default:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
        static func buttonText() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 241/255, green: 136/255, blue: 132/255, alpha: 1)
            default:
                return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
            }
        }
        static func pinkColor() -> UIColor {
            switch ColorManager.shared.colorMode {
            case .dark:
                return UIColor(red: 220/255, green: 074/255, blue: 97/255, alpha: 1)
            default:
                return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
            }
        }
    }
}
