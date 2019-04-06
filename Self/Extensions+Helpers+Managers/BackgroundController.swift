import Foundation
import UIKit

class BackgroundController {
    
    static let shared = BackgroundController()
    var backgroundContainer: UIViewController?
    
    lazy var background: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        
        let circleOnePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwoPath = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circlePaths = CGMutablePath()
        circlePaths.addPath(circleOnePath.cgPath)
        circlePaths.addPath(circleTwoPath.cgPath)
        
        shapeLayer.fillColor = UIColor.app.other().cgColor
        shapeLayer.path = circlePaths
        shapeLayer.zPosition = -1
        return shapeLayer
    }()
    
    // MARK: - Init
    func addBackground() {
        self.backgroundContainer?.view.layer.addSublayer(background)
        self.backgroundContainer?.view.backgroundColor = UIColor.app.background()
    }
    
    func tabSwitchAnimation(_ selectedIndex: Int) {
        let newBackgroundPaths = CGMutablePath()
        if selectedIndex == 0 {
            // Highlights
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 450,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 400,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if selectedIndex == 1 {
            // Home
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        } else if selectedIndex == 2 {
            // Challenges
            let circleOne = UIBezierPath(arcCenter: CGPoint(x: -50,y: 250), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 0,y: 650), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
        }
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        background.path = newBackgroundPaths
        background.add(backgroundAnimation, forKey: "path")
    }
    
    func clearScreen() {
        let newBackgroundPaths = CGMutablePath()
        
        let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        newBackgroundPaths.addPath(circleOne.cgPath)
        newBackgroundPaths.addPath(circleTwo.cgPath)
        
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        background.path = newBackgroundPaths
        background.add(backgroundAnimation, forKey: "path")
    }
    
    func fillScreen() {
        let newBackgroundPaths = CGMutablePath()

            let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(1000), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            newBackgroundPaths.addPath(circleOne.cgPath)
            newBackgroundPaths.addPath(circleTwo.cgPath)
     
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        background.path = newBackgroundPaths
        background.add(backgroundAnimation, forKey: "path")
    }
    
    func resetBackground() {
        let newBackgroundPaths = CGMutablePath()
        
        let circleOne = UIBezierPath(arcCenter: CGPoint(x: 100,y: 350), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleTwo = UIBezierPath(arcCenter: CGPoint(x: 300,y: 600), radius: CGFloat(80), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        newBackgroundPaths.addPath(circleOne.cgPath)
        newBackgroundPaths.addPath(circleTwo.cgPath)
        
        let backgroundAnimation = CABasicAnimation(keyPath: "path")
        backgroundAnimation.fromValue = background.path
        backgroundAnimation.toValue = newBackgroundPaths
        backgroundAnimation.duration = 0.3
        backgroundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        background.path = newBackgroundPaths
        background.add(backgroundAnimation, forKey: "path")
    }
    
}
