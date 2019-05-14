import UIKit
// swiftlint:disable nesting
// swiftlint:disable switch_case_alignment

extension UIColor {
    
    struct App {
        struct General {
            static func blackWhite() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            default:    return UIColor(red: 044/255, green: 044/255, blue: 044/255, alpha: 1)
                }}
            static func contrastBlackWhite() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 000/255, green: 000/255, blue: 000/255, alpha: 1)
            default: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                }}
        }
        struct Background {
            static func primary() -> UIColor { switch ColorManager.getActiveColorMode() {
//            case .dark: return UIColor(red: 029/255, green: 038/255, blue: 095/255, alpha: 1)
            case .dark: return UIColor(red: 078/255, green: 088/255, blue: 115/255, alpha: 1)
            default:    return UIColor(red: 249/255, green: 241/255, blue: 233/255, alpha: 1)
            }}
            static func secondary() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 094/255, green: 104/255, blue: 131/255, alpha: 1)
            default:    return UIColor(red: 243/255, green: 230/255, blue: 213/255, alpha: 1)
            }}
        }
        struct Text {
            static func text() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 252/255, green: 245/255, blue: 235/255, alpha: 1)
            default:    return UIColor(red: 085/255, green: 093/255, blue: 111/255, alpha: 1)
            }}
            static func alt() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)
            default:    return UIColor(red: 129/255, green: 140/255, blue: 170/255, alpha: 1)
                }}
            static func errorState() -> UIColor { switch ColorManager.getActiveColorMode() {
            case .dark: return UIColor(red: 254/255, green: 133/255, blue: 142/255, alpha: 0.8)
            default:    return UIColor(red: 254/255, green: 133/255, blue: 142/255, alpha: 0.8)
            }}
        }
        struct Button {
            struct Primary {
                static func fill() -> UIColor { switch ColorManager.getActiveColorMode() {
                case .dark: return UIColor(red: 245/255, green: 165/255, blue: 114/255, alpha: 1)
                default:    return UIColor(red: 245/255, green: 165/255, blue: 114/255, alpha: 1)
                }}
                static func text() -> UIColor { switch ColorManager.getActiveColorMode() {
                case .dark: return UIColor(red: 100/255, green: 044/255, blue: 044/255, alpha: 1)
                default:    return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                }}
            }
            struct Tag {
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
        struct Interactive {
            struct Selectable {
                static func selected() -> UIColor { switch ColorManager.getActiveColorMode() {
                case .dark: return UIColor(red: 241/255, green: 136/255, blue: 132/255, alpha: 1)
                default:    return UIColor(red: 010/255, green: 010/255, blue: 050/255, alpha: 1)
                }}
                static func unselected() -> UIColor { switch ColorManager.getActiveColorMode() {
                case .dark: return UIColor(red: 150/255, green: 166/255, blue: 254/255, alpha: 1)
                default:    return UIColor(red: 094/255, green: 086/255, blue: 113/255, alpha: 0.8)
                }}
            }
        }
        struct Effects {
            static func blurEffect() -> UIVisualEffect { switch ColorManager.getActiveColorMode() {
            case .dark: return UIBlurEffect(style: .dark)
            default:    return UIBlurEffect(style: .light)
            }}
        }
    }
}
