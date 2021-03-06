import UIKit
import SnapKit

//: TODO: This class needs a lot of tidying up
final class MoodLoggingMoodViewController: ViewController {
    
    // Dependencies and Delegates
    weak var dataCollector: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    var emotionManager: EmotionManager = EmotionManager()
    
    lazy var initialPrompt: UILabel = {
        let label = ParaLabel("Log your Mood by tapping on the screen", .centerPageText)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        label.alpha = 0.4
        label.shadowColor = UIColor.App.Background.primary().withAlphaComponent(0.4)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    lazy var tapToConfirm: UIButton = {
        let button = UIButton()
        button.setTitle("+ New Log", for: .normal)
        button.isEnabled = true
        button.setTitleColor(UIColor.App.Button.Primary.text(), for: .normal)
        button.setTitleColor(UIColor.App.Button.Primary.text().withAlphaComponent(0.6), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.frame.size = CGSize(width: 150, height: 40)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.App.Button.Primary.fill()
        button.addTarget(self, action: #selector(tappedCircle), for: .touchUpInside)
        button.addTarget(self, action: #selector(focusButton), for: .touchDown)
        button.addTarget(self, action: #selector(focusButton), for: .touchDragEnter)
        button.addTarget(self, action: #selector(unFocusButton), for: .touchDragExit)
        button.addTarget(self, action: #selector(unFocusButton), for: .touchCancel)
        button.layer.cornerRadius = 20
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        button.alpha = 0.6
        button.clipsToBounds = false
        return button
    }()
    
    lazy var exitButton = IconButton(UIImage(named: "back")!, action: #selector(exit), .standard)
    lazy var infoButton = IconButton(UIImage(named: "info-circle")!, action: #selector(info), .standard)

    lazy var markSpotlight: CAGradientLayer = {
        let diameter: CGFloat = 50
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: (self.view.frame.width / 2), y: (self.view.frame.height / 2), width: diameter, height: diameter)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.type = .radial
        gradient.cornerRadius = (diameter / 2)
        gradient.masksToBounds = true
        gradient.opacity = 0.9
        gradient.locations = [0.0, 0.8, 1]
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.backgroundFilters = [CIFilter(name: "CIGaussianBlur", parameters: [kCIInputRadiusKey: 5])!]
        return gradient
    }()
    
    lazy var pulseAnimations: CAAnimationGroup = {
        let animations = CAAnimationGroup()
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = CATransform3DMakeScale(1, 1, 0.5)
        transformAnimation.toValue = CATransform3DMakeScale(1.4, 1.4, 1)
        transformAnimation.duration = 1.5
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 1.5
        
        animations.animations = [transformAnimation, opacityAnimation]
        animations.duration = 1.5
        animations.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animations.autoreverses = true
        animations.repeatCount = Float.greatestFiniteMagnitude
        
        return animations
    }()
    
    lazy var shadowAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.1
        animation.toValue = 0.3
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }()
    
    lazy var helpScreen: UIViewController = {
        let vc = HelpMoodLoggingMoodViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    
    var isMoodMarked: Bool = false
    var markAdded: Bool = false
    var primaryBackgroundColour = UIColor.white.withAlphaComponent(0)
    var userRatings: (valence: Double, arousal: Double) = (0, 0)
    var emotion: Mood.Emotion?
    
    var backgroundLabels: [(label: CATextLayer, moodLog: Mood.Log?)] = []
    
}

// MARK: - Override Methods
extension MoodLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundLabels()
        view.layer.addSublayer(markSpotlight)
        view.backgroundColor = .clear
        view.layer.backgroundColor = UIColor.clear.cgColor
        setupChildViews()
        exitButton.tintColor = UIColor.darkText
        view.bringSubviewToFront(initialPrompt)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        markSpotlight.add(pulseAnimations, forKey: nil)
        screenSliderDelegate?.gestureScrollingEnabled = false
        screenSliderDelegate?.pageIndicator.isVisible = false
        screenSliderDelegate?.backwardButton.isVisible = false
        screenSliderDelegate?.forwardButton.isVisible = false
        screenSliderDelegate?.forwardNavigationEnabled = false
        tapToConfirm.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenSliderDelegate?.gestureScrollingEnabled = false
        screenSliderDelegate?.pageIndicator.isVisible = false
        screenSliderDelegate?.backwardButton.isVisible = false
        screenSliderDelegate?.forwardButton.isVisible = false
    }
}

// MARK: - Class Methods
extension MoodLoggingMoodViewController: UIGestureRecognizerDelegate {
    
    // Gesture Handling
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard !helpScreen.isBeingPresented else { return false }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        addMark()
        updateMark(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateMark(touch: touch)
        CATransaction.commit()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateMark(touch: touch)
        setMark()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateMark(touch: touch)
        setMark()
    }
}

// Action Methods
extension MoodLoggingMoodViewController {
    
    @objc func tappedCircle(sender: UIButton) {
        unFocusButton(sender)
        saveMarkedMood()
    }
    
    @objc func exit(sender: IconButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func info(sender: IconButton) {
        self.definesPresentationContext = true
        present(helpScreen, animated: true)
    }
    
    @objc func focusButton(_ button: UIButton) {
        let duration = 0.8
        
        self.tapToConfirm.layer.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius += 1.0
        button.layer.shadowOpacity -= 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width + 0.5, height: button.layer.shadowOffset.height + 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha += 0.2
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    @objc func unFocusButton(_ button: UIButton) {
        let duration = 0.4
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius -= 1.0
        button.layer.shadowOpacity += 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width - 0.5, height: button.layer.shadowOffset.height - 4.0)
        CATransaction.commit()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: {
                button.alpha -= 0.2
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        self.tapToConfirm.layer.add(shadowAnimation, forKey: nil)
    }
}

// High Level - Mark related Methods
extension MoodLoggingMoodViewController {
    
    // Other Methods
    /// Get's the mark and coordinates and uses them to create an emotion.
    func updateMark(touch: UITouch) {
        
        let location = touch.location(in: self.view)
        
        /// Create appropriate mood
        userRatings = calculateMoodFromScreenPosition(
            x: location.x,
            y: location.y
        )
        
        emotionManager.getEmotion(
            withValence: userRatings.valence,
            withArousal: userRatings.arousal
        ) { emotion in
            self.emotion = emotion
        }
            
        updateLabelsRelativeToPosition(tapPosition: (location.x, location.y))
        updateBackground(xScale: (location.x / view.frame.width), yScale: (location.y / view.frame.height))
        
        /// - Update tap to confirm and circle positions
        // TODO: Width Bug, Currently need to hard code the constraints
        let verticalBuffer: CGFloat = markSpotlight.frame.height + 30
        let horizontalBuffer: CGFloat = markSpotlight.frame.width + 90
        
        tapToConfirm.frame.origin.x = location.x
        tapToConfirm.frame.origin.y = location.y + verticalBuffer
        
        if (tapToConfirm.frame.origin.x - 90) < 0 {
            tapToConfirm.frame.origin.x = location.x + horizontalBuffer
            tapToConfirm.frame.origin.y = location.y
        }
        
        if (tapToConfirm.frame.origin.x + 90) > self.view.frame.width {
            tapToConfirm.frame.origin.x = location.x - horizontalBuffer
            tapToConfirm.frame.origin.y = location.y
        }
        
        if (tapToConfirm.frame.origin.y - 30) < 0 {
            tapToConfirm.frame.origin.y = 40
        }
        
        if (tapToConfirm.frame.origin.y + 30) > self.view.frame.height {
            tapToConfirm.frame.origin.y = location.y - verticalBuffer
        }
    }
    
    // When the user starts a tap
    func addMark() {
        
        /// Remove All Overlays
        let duration = 0.3
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: [.curveEaseIn, .allowAnimatedContent, .beginFromCurrentState, .transitionCrossDissolve, .preferredFramesPerSecond60],
                       animations: {
                        self.exitButton.alpha = 0.0
                        self.exitButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        
                        self.infoButton.alpha = 0.0
                        self.infoButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        
                        self.tapToConfirm.alpha = 0
                        self.tapToConfirm.frame.origin.x = (self.markSpotlight.frame.origin.x - (self.tapToConfirm.frame.size.width / 2))
                        self.tapToConfirm.frame.origin.y = (self.markSpotlight.frame.origin.y - (self.tapToConfirm.frame.size.height / 2))
        })
        
        self.tapToConfirm.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        self.exitButton.layer.shadowRadius = 0.0
        self.exitButton.layer.shadowOpacity = 0.0
        self.exitButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        self.infoButton.layer.shadowRadius = 0.0
        self.infoButton.layer.shadowOpacity = 0.0
        self.infoButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        self.tapToConfirm.layer.shadowRadius = 0.0
        self.tapToConfirm.layer.shadowOpacity = 0.0
        self.tapToConfirm.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        CATransaction.commit()
        
        markSpotlight.removeAllAnimations()
        /// Shrink the spotlight and stop pusling animation
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        self.markSpotlight.transform = CATransform3DMakeScale(0.7, 0.7, 1)
        CATransaction.commit()
        initialPrompt.removeFromSuperview()
    }
    
    // Called when the tap finishes
    func setMark() {
        /// Add tapToConfirm to the view if it isn't already
        if !tapToConfirm.isDescendant(of: self.view) {
            view.addSubview(tapToConfirm)
        }
        
        /// Enable the button
        tapToConfirm.isEnabled = true
        
        /// Position and then animate the confirmation button
        let yDiff: CGFloat = self.markSpotlight.frame.origin.y - self.tapToConfirm.frame.origin.y
        let xDiff: CGFloat = self.markSpotlight.frame.origin.x - self.tapToConfirm.frame.origin.x
        self.tapToConfirm.frame.origin.x += xDiff
        self.tapToConfirm.frame.origin.y += yDiff
        
        let buttonDuration = 1.0
        UIView.animate(withDuration: buttonDuration,
                       delay: 0.05,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 10,
                       options: [.curveEaseIn, .allowUserInteraction, .allowAnimatedContent],
                       animations: {
                        self.tapToConfirm.alpha = 0.8
                        self.tapToConfirm.frame.origin.y -= yDiff
                        self.tapToConfirm.frame.origin.x -= xDiff
                        self.tapToConfirm.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(buttonDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            self.tapToConfirm.layer.shadowRadius = 4.0
            self.tapToConfirm.layer.shadowOpacity = 0.35
            self.tapToConfirm.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        CATransaction.commit()
        self.tapToConfirm.layer.add(shadowAnimation, forKey: nil)
        
        /// Reshow hidden views with quick animation
        let overlayDuration = 0.5
        UIView.animate(withDuration: overlayDuration,
                       delay: 0.3,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                        self.exitButton.alpha = 0.4
                        self.exitButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
                        self.infoButton.alpha = 0.3
                        self.infoButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(overlayDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            self.exitButton.layer.shadowRadius = 3.0
            self.exitButton.layer.shadowOpacity = 0.4
            self.exitButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
            self.infoButton.layer.shadowRadius = 3.0
            self.infoButton.layer.shadowOpacity = 0.5
            self.infoButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        CATransaction.commit()
        
        markSpotlight.add(pulseAnimations, forKey: nil)
        /// Readd the spotlight and pulse animation
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
            self.markSpotlight.transform = CATransform3DMakeScale(1, 1, 1)
        CATransaction.commit()
        
        /// Set MoodMarked to true
        guard markAdded == false else { return }
        isMoodMarked = true
        markAdded = true
    }
    
    // Called when the user taps the button
    func saveMarkedMood() {
        
        guard isMoodMarked == true else { return }
        
        /// Disable the button to prevent further accidental double taps
        self.tapToConfirm.isEnabled = false
        
        /// Send this screens data to the delegate before attempting to continue
        dataCollector?.valenceRating = userRatings.valence
        dataCollector?.arousalRating = userRatings.arousal
        dataCollector?.emotion = emotion
        
        /// Animate the delegates background
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
        dataCollector?.background.startPoint = CGPoint(x: (dataCollector?.background.startPoint.x)!, y: 0)
        CATransaction.commit()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
        dataCollector?.background.colors =
            [primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor]
        CATransaction.commit()
        
        /// Enable forward navigation and gestureSwiping again
        self.screenSliderDelegate?.forwardNavigationEnabled = true
        self.screenSliderDelegate?.gestureScrollingEnabled = true
        
        /// Informt he delegate to attempt to proceed
        self.screenSliderDelegate?.goToNextScreen()
        
        self.tapToConfirm.setTitle("Edit Log", for: .normal)
    }
    
    func calculateMoodFromScreenPosition(x: CGFloat, y: CGFloat) -> (valence: Double, arousal: Double) {
        let arousalCoordinates = -convertCoordinateToRating(coordinate: y, range: self.view.frame.height)
        let valenceCoordinates = convertCoordinateToRating(coordinate: x, range: self.view.frame.width)
        let arousal: Double = Double(arousalCoordinates)
        let valence: Double = Double(valenceCoordinates)
        return (valence: valence, arousal: arousal)
    }
    
    func convertCoordinateToRating(coordinate: CGFloat, range: CGFloat) -> CGFloat {
        let scale = range / 2
        let rating = (coordinate - scale) / scale
        let ratingRounded = CGFloat(round(100*rating)/100)
        return ratingRounded
    }
}

// Updating the screen
extension  MoodLoggingMoodViewController {
    
    func updateBackground(xScale: CGFloat, yScale: CGFloat) {
        /// xScale is valence
        /// yScale is Arousal
        /// - Calculate each of the colour attributes. Format: initialValue Operator (mutableRange * mutator)
        let red     = 0.9 - (0.8 * xScale)   /// 0.9 - 0.1
        let green   = 0.1 + (0.8 * xScale)   /// 0.1 - 0.9
        let blue    = 0.1 + (0.8 * yScale)   /// 0.1 - 0.9
        let alpha   = 0.6 - (0.2 * yScale)   /// 0.6 - 0.4
        
        let diff: CGFloat = 0.25
        
        primaryBackgroundColour  = UIColor(red: red, green: green, blue: blue, alpha: alpha      )         /// Base (center)
        let topLeft              = UIColor(red: red, green: green-diff, blue: blue-diff, alpha: alpha      ).cgColor /// +Arousal, -Valence (TOP Left) (blue)
        let topRight             = UIColor(red: red-diff, green: green, blue: blue-diff, alpha: alpha      ).cgColor /// +Arousal, +Valence (Top RIGHT) (green)
        let bottomRight          = UIColor(red: red-diff, green: green, blue: blue, alpha: alpha-diff ).cgColor /// -Arousal, +Valence (BOTTOM Right) (alpha)
        let bottomLeft           = UIColor(red: red, green: green-diff, blue: blue, alpha: alpha-diff ).cgColor /// -Arousal, -Valence (Bottom LEFT) (red)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
        // view.backgroundColor = colour
        markSpotlight.colors = [primaryBackgroundColour.withAlphaComponent(0.9).cgColor,
                                primaryBackgroundColour.withAlphaComponent(0.5).cgColor,
                                primaryBackgroundColour.withAlphaComponent(0).cgColor]
        dataCollector?.background.colors = [topLeft, topRight, bottomRight, bottomLeft, topLeft]
        dataCollector?.background.startPoint = CGPoint(x: xScale, y: yScale)
        CATransaction.commit()
        
    }
    
    func addBackgroundLabels() {
        dataCollector?.moodManager.getAllMoodlogs { moods in
            guard let moods = moods, moods.count > 0 else {
                self.addEmotionLabels()
                return
            }
            self.addMoodRecords(moods)
        }
    }
    
    private func addMoodRecords(_ moodRecords: [Mood.Log]) {
        for log in moodRecords {
            /// - Create and style the label
            let label = CATextLayer()
            label.font = CGFont(UIFont.systemFont(ofSize: 0, weight: UIFont.Weight.light).fontName as CFString)
            label.opacity = 0
            label.fontSize = 0.0
            label.shadowRadius = 0
            label.shadowOpacity = 0
            label.contentsScale = UIScreen.main.scale
            label.alignmentMode = .center
            label.frame.size = CGSize(width: 200, height: 20)
            label.foregroundColor = UIColor.App.Text.text().cgColor
            label.shadowOffset = CGSize(width: 0, height: 0)
            label.allowsFontSubpixelQuantization = false
            
            /// - Add the emotion name
            label.string = "\(log.headline)"
            
            /// - Work out the labels center position
            var left: CGFloat   = CGFloat(self.view.frame.width / 2) - (label.frame.width / 2)          /// Get the center horizontal position of the view and label
            var top: CGFloat    = CGFloat(self.view.frame.height / 2) - (label.frame.height / 2)        /// Get the center vertical position of the view and label
            
            /// - adjust the position by the emotion multiplier
            left = left * CGFloat(log.valenceRating + 1)                           /// Adjust that position by the multiplier
            top = self.view.frame.height - (top * CGFloat(log.arousalRating + 1))  /// Adjust that position by the multiplier (also reverse it so it aligns with the scale, bottom to top)
            
            /// - Set the position
            label.frame.origin.x = left
            label.frame.origin.y = top
            
            self.view.layer.addSublayer(label)
            self.backgroundLabels.append((label, log))
            
            let moodDateLabel = CATextLayer()
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            moodDateLabel.string = dateformatter.string(from: log.timestamp)
            moodDateLabel.allowsFontSubpixelQuantization = false
            moodDateLabel.contentsScale = UIScreen.main.scale
            moodDateLabel.fontSize = 10
            moodDateLabel.opacity = 0.8
            moodDateLabel.alignmentMode = .center
            moodDateLabel.font = CGFont(UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.ultraLight).fontName as CFString)
            moodDateLabel.frame.size = label.frame.size
            moodDateLabel.frame.origin = CGPoint(x: moodDateLabel.frame.origin.x, y: 5 - moodDateLabel.frame.size.height)
            moodDateLabel.foregroundColor = label.foregroundColor
            
            print(label.frame, moodDateLabel.frame)

            /// - Add the label
            label.addSublayer(moodDateLabel)
        }
        
        // Force unqrapping here isn't ideal, but since this would only be run if the collection contains mood labels it should be okay
        var latestLog: (label: CATextLayer, moodLog: Mood.Log?)
        if backgroundLabels.count < 2 {
            latestLog = backgroundLabels.min { a, b in a.moodLog!.timestamp < b.moodLog!.timestamp }!
        } else {
            latestLog = backgroundLabels.first!
        }
        let latestLogLabel = latestLog.label
        latestLogLabel.opacity = 0.8
        latestLogLabel.fontSize = 14
        
        let latestLogTitle = CATextLayer()
        latestLogTitle.string = "Your Last Log"
        latestLogTitle.opacity = 0.8
        latestLogTitle.allowsFontSubpixelQuantization = false
        latestLogTitle.contentsScale = UIScreen.main.scale
        latestLogTitle.fontSize = 10
        latestLogTitle.alignmentMode = .center
        latestLogTitle.font = CGFont(UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light).fontName as CFString)
        latestLogTitle.frame.size = CGSize(width: latestLogLabel.frame.size.width, height: 15)
        latestLogTitle.frame.origin.x = CGFloat(latestLogTitle.frame.origin.x)
        latestLogTitle.frame.origin.y -= (latestLogLabel.frame.size.height + 15)
        
        latestLogLabel.addSublayer(latestLogTitle)
    }
    
    func addEmotionLabels() {
        emotionManager.emotions { allemotions in
            for emotion in allemotions {
                
                /// - Create and style the label
                let label = CATextLayer()
                label.font = CGFont(UIFont.systemFont(ofSize: 0, weight: UIFont.Weight.ultraLight).fontName as CFString)
                label.masksToBounds = false
                label.opacity = 0
                label.fontSize = 0.0
                label.shadowRadius = 0
                label.shadowOpacity = 0
                label.contentsScale = UIScreen.main.scale
                label.alignmentMode = .center
                label.frame.size = CGSize(width: 200, height: 30)
                label.foregroundColor = UIColor.App.Text.text().cgColor
                label.shadowOffset = CGSize(width: 0, height: 0)
                label.allowsFontSubpixelQuantization = false
                
                /// - Add the emotion name
                label.string = "\(emotion.emoji) \(emotion.friendly)"
                
                /// - Work out the labels center position
                var left: CGFloat   = CGFloat(self.view.frame.width / 2) - (label.frame.width / 2)          /// Get the center horizontal position of the view and label
                var top: CGFloat    = CGFloat(self.view.frame.height / 2) - (label.frame.height / 2)        /// Get the center vertical position of the view and label
                
                /// - adjust the position by the emotion multiplier
                left = left * CGFloat(emotion.valenceMultiplier)                           /// Adjust that position by the multiplier
                top = self.view.frame.height - (top * CGFloat(emotion.arousalMultiplier))  /// Adjust that position by the multiplier (also reverse it so it aligns with the scale, bottom to top)
                
                /// - Set the position
                label.frame.origin.x = left
                label.frame.origin.y = top
                
                /// - Add the label
                self.view.layer.addSublayer(label)
                self.backgroundLabels.append((label, nil))
            }
        }
    }
    
    func updateLabelsRelativeToPosition(tapPosition tap:(x: CGFloat, y: CGFloat)) {
        
        for label in backgroundLabels {
            let label = label.label
            
            let largestScreenDistance = (view.frame.size.width / 2) + (view.frame.size.height / 2)
            
            /// - Calculate the frame radius now (axis size divide by 2), to help keep the code clean later on.
            let radius: (width: CGFloat, height: CGFloat) = (
                width: label.frame.width / 2,
                height: label.frame.height / 2
            )
            
            /// - Calculate the position of the center of the label
            let position: (x: CGFloat, y: CGFloat) = (
                x: label.frame.origin.x + radius.width,
                y: label.frame.origin.y + radius.height
            )
            
            /// - Work out how close the user is to this emotion
            let distanceFromTap = (
                x: abs(position.x - tap.x),
                y: abs(position.y - (tap.y - 25)), /// Subtracting 25 so the new tap is slightly above the actual tap (and hopefully above the thumb)
                total: abs(position.x - tap.x) + abs(position.y - tap.y)
            )
            
            /// - Create a Multiplier
            let catchmentDistance = largestScreenDistance / 3                       /// The fraction of the screen around the label the tap must be in before multipliers take effect
            let bufferedDistance = (distanceFromTap.x+distanceFromTap.y) - 25       /// Buffer so that multipliers reach their max value before the user gets too close
            var multiplier = 1 - (bufferedDistance / catchmentDistance)             /// Fraction representing 1 as the position of the label and 0 as the furthest possible distance || 0.8
            multiplier = (multiplier < 0) ? 0 : ((multiplier > 1) ? 1 : multiplier) /// Restrict the multiplier to between 0 and 1
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)                                                           /// Begin CATransaction with duration for any CA Layers
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
            
            /// - Apply the Multipliers
            label.opacity = Float(0.7 * multiplier)                                              /// Fade the label in as the tap gets closer, up to 0.9 opacity
            label.fontSize = (14 * multiplier)                                                   /// Make the label larger as the tap gets closer, up to size 12
            if let dateLayer = label.sublayers?.first(where: {$0.isMember(of: CATextLayer.self)}) as? CATextLayer {
                dateLayer.fontSize = (10 * multiplier)
                dateLayer.frame.origin.y = (5 - dateLayer.frame.size.height) * multiplier
                
                if let headline = label.sublayers?.last(where: {$0.isMember(of: CATextLayer.self)}) as? CATextLayer {
                    if headline != dateLayer {
                        headline.fontSize = (10 * multiplier)
                        headline.frame.origin.y = (-label.frame.size.height - headline.frame.size.height) * multiplier
                    }
                }
            }
            label.shadowRadius = CGFloat(3.0 * multiplier)                                       /// Animate shadow
            label.shadowOpacity = Float(0.8 * multiplier)                                        /// Animate opacity
            label.shadowOffset = CGSize(width: 0, height: CGFloat(6.0 * multiplier).rounded())   /// Animate offset to give layer depth
            markSpotlight.frame.origin = CGPoint(x: tap.x - (markSpotlight.frame.width / 2), y: tap.y - (markSpotlight.frame.width / 2))
            
            CATransaction.commit()
        }
        
    }
    
}

// MARK: - View Building
extension MoodLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        view.addSubview(exitButton)
        view.addSubview(infoButton)
        view.addSubview(initialPrompt)
        infoButton.applyConstraints(forPosition: .topRight, inVC: self)
        exitButton.applyConstraints(forPosition: .topLeft, inVC: self)
        initialPrompt.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
