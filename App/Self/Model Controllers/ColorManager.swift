import UIKit

typealias AppColorMode = ColorManager.AppColorMode

class ColorManager {
    
    static private var sharedInstance: ColorManager?
    private(set) var colorMode: AppColorMode = .dark // Default
    
}

// MARK: - Color Mode Functions
extension ColorManager {
    
    static func getActiveColorMode() -> AppColorMode {
        
        if sharedInstance == nil {
            sharedInstance = ColorManager()
        }
        
        updateColorMode()
        return sharedInstance!.colorMode
    }
}

// Mark: - Updating the Color Mode
extension ColorManager {
    static func updateColorMode() {
        switch AccountManager.shared().accountRef?.settings.userColorMode {
        case .light?:
                sharedInstance!.colorMode = .light
        case .dark?:
                sharedInstance!.colorMode = .dark
            default:
                sharedInstance!.colorMode = getAutoColor()
        }
    }
    
    static private func getAutoColor() -> AppColorMode {
        if  Calendar.current.component(.hour, from: Date()) > 08 &&
            Calendar.current.component(.hour, from: Date()) < 19 {
            return AppColorMode.light
        } else {
            return AppColorMode.dark
        }
    }
    
}

// MARK: - Color Mode Options
extension ColorManager {
    enum AppColorMode: String, CaseIterable {
        case light
        case dark
        case auto
        
        var key: String {
            return rawValue
        }
    
        static func matchCase(string:String) -> AppColorMode {
            switch string {
                case self.light.rawValue:   return .light
                case self.dark.rawValue:    return .dark
                default:                    return .auto
            }
        }
    }
}
