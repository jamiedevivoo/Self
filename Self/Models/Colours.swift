import UIKit

extension UIColor {
    
    struct app {
        struct standard {
            static func blackWhite() -> UIColor { switch ColorManager.getActiveColorMode() {
                case .dark: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                default:    return UIColor(red: 000/255, green: 000/255, blue: 000/255, alpha: 1)
            }}
        }
        struct background {
            static func primaryBackground() -> UIColor { switch ColorManager.getActiveColorMode() {
                    case .dark: return UIColor(red: 029/255, green: 038/255, blue: 095/255, alpha: 1)
                    default:    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }}
            static func secondaryBackground() -> UIColor { switch ColorManager.getActiveColorMode() {
                    case .dark: return UIColor(red: 019/255, green: 025/255, blue: 083/255, alpha: 1)
                    default:    return UIColor(red: 255/255, green: 244/255, blue: 240/255, alpha: 1)
            }}
        }
        struct text {
            static func solidText() -> UIColor { switch ColorManager.getActiveColorMode() {
                    case .dark: return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)
                    default:    return UIColor(red: 010/255, green: 010/255, blue: 050/255, alpha: 1)
            }}
        }
        struct button {
            struct primary {
                static func fill() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 220/255, green: 074/255, blue: 97/255, alpha: 1)
                        default:    return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
                }}
                static func text() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                        default:    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                    }}
            }
            struct tag {
                static func fill() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 059/255, green: 050/255, blue: 131/255, alpha: 1)
                        default:    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                }}
                static func text() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 241/255, green: 136/255, blue: 132/255, alpha: 1)
                        default:    return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
                }}
            }
        }
        struct interactive {
            struct selectable {
                static func selected() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 241/255, green: 136/255, blue: 132/255, alpha: 1)
                        default:    return UIColor(red: 010/255, green: 010/255, blue: 050/255, alpha: 1)
                }}
                static func unselected() -> UIColor { switch ColorManager.getActiveColorMode() {
                        case .dark: return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)
                        default:    return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 1)
                }}
            }
        }
    }
}
