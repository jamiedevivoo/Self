import UIKit

class ColorManager {
    
    static let shared = ColorManager()
        
    var colorMode: ColorMode = .dark // Default
    
    init() {
        updateColorMode()
    }
    
}

// MARK: - Color Mode Functions
extension ColorManager {
    func updateColorMode() {
        if Calendar.current.component(.hour, from: Date()) > 08 && Calendar.current.component(.hour, from: Date()) < 19 {
            colorMode = ColorMode.light
        } else {
            colorMode = ColorMode.dark
        }
    }
}

// MARK: - Color Mode Options
extension ColorManager {
    enum ColorMode {
        case light
        case dark
    }
}
