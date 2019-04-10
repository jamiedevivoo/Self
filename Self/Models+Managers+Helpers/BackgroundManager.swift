import UIKit

class BackgroundManager {
    
    static let shared = BackgroundManager() // Singleton
    var backgroundContainer: UIViewController? {
        didSet {
            BackgroundManager.shared.addBackgroundToView()
            resetBackground()
        }
    }
    
    private lazy var background: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.app.other().cgColor
        shapeLayer.path = getBackgroundPath(for: .homeScreen)
        shapeLayer.zPosition = -1
        return shapeLayer
    }()
    
}

// MARK: - Setup Functions
extension BackgroundManager {
    func addBackgroundToView() {
        self.backgroundContainer?.view.layer.addSublayer(background)
        self.backgroundContainer?.view.backgroundColor = UIColor.app.background()
    }
}

// MARK: - Animation Functions
extension BackgroundManager {
    
    private func animateBackground(_ newBackgroundPaths: CGPath, animationDuration: CFTimeInterval = 0.3) {
        
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = self.background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = animationDuration
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        self.background.path = newBackgroundPaths
        self.background.add(backgroundAnimation, forKey: "path")
    }
    
    func animateBackgroundToTabOption(_ selectedIndex: Int) {
        switch selectedIndex {
            case 0: animateBackground(getBackgroundPath(for: .highlightsScreen))
            case 2: animateBackground(getBackgroundPath(for: .actionsScreen))
            default: animateBackground(getBackgroundPath(for: .homeScreen))
        }
    }
    
    func clearScreen() {
        animateBackground(getBackgroundPath(for: .hidden))
    }
    func fillScreen() {
        animateBackground(getBackgroundPath(for: .fullScreen))
    }
    
    func resetBackground() {
        animateBackground(getBackgroundPath(for: .homeScreen), animationDuration: 1)
    }
    
}

// MARK: - Background Settings
extension BackgroundManager {
    
    enum BackgroundOption {
        case homeScreen
        case highlightsScreen
        case actionsScreen
        case fullScreen
        case hidden
    }
    
    private func getBackgroundPath(for option:BackgroundOption) -> CGPath {
        let backgroundPath = CGMutablePath()

        switch option {
        case .homeScreen:
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
        case .highlightsScreen:
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 450,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 400,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
        case .actionsScreen:
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: -50,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 0,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
        case .fullScreen:
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(1000), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
        default: // .hidden
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
            backgroundPath.addPath(UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath)
        }
        
        return backgroundPath
    }
    
}

