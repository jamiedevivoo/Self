import UIKit
import SnapKit

//: TODO: This class needs a lot of tidying up
final class MoodLoggingMoodViewController: ViewController {

    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    weak var screenSlider: ScreenSliderViewController?
    
    lazy var tapToConfirm: UIButton = {
        let button = UIButton()
        button.setTitle("+ New Log", for: .normal)
        button.isEnabled = true
        button.setTitleColor(UIColor.app.button.primary.text(), for: .normal)
        button.setTitleColor(UIColor.app.button.primary.text().withAlphaComponent(0.6), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.frame.size = CGSize(width: 150, height: 40)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.app.button.primary.fill()
        button.addTarget(self, action: #selector(tappedCircle), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDown)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        button.layer.cornerRadius = 20
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        button.alpha = 0.6
        button.clipsToBounds = false
        return button
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named:"back")
        btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(btnImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.darkText
        button.addTarget(self, action: #selector(exit), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDown)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        button.alpha = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return button
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named:"info-circle")?.withRenderingMode(.alwaysTemplate)
        btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(btnImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(info), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDown)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        button.alpha = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return button
    }()

    lazy var markSpotlight: CAGradientLayer = {
        let diameter: CGFloat = 60
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: (self.view.frame.width / 2), y: (self.view.frame.height / 2), width: diameter, height: diameter)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.type = .radial
        gradient.cornerRadius = (diameter / 2)
        gradient.masksToBounds = true
        gradient.opacity = 0.9
        gradient.locations = [0.0, 0.8, 1]
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.backgroundFilters = [CIFilter(name: "CIGaussianBlur",parameters: [kCIInputRadiusKey: 5])!]
        return gradient
    }()
    
    lazy var pulseAnimation: CAAnimationGroup = {
        let animations = CAAnimationGroup()
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = CATransform3DMakeScale(1.25, 1.25, 1.25)
        transformAnimation.toValue = CATransform3DMakeScale(1, 1, 0.5)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        transformAnimation.fromValue = 0.9
        transformAnimation.toValue = 1.0
        
        animations.animations = [transformAnimation, opacityAnimation]
        animations.duration = 1.5
        animations.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animations.autoreverses = true
        animations.repeatCount = Float.greatestFiniteMagnitude

        return animations
    }()
    
    var isMoodMarked:Bool = false
    var markAdded: Bool = false
    var primaryBackgroundColour = UIColor.white.withAlphaComponent(0)
    var userRatings: (valence: Double, arousal: Double) = (0,0)
    var emotion: Mood.Emotion?
    
    var emotionLabelCollection: [CATextLayer] = []
    
}


// MARK: - Override Methods
extension MoodLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmotionLabels()
        view.layer.addSublayer(markSpotlight)
        view.backgroundColor = .clear
        setupChildViews()
        screenSlider?.forwardNavigationEnabled = false
        super.navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        screenSlider?.gestureSwipingEnabled = false
    }
}


// MARK: - Class Methods
extension MoodLoggingMoodViewController {
    
    // Gesture Handling
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
    
    @objc func tappedCircle(sender:UIButton ) {
        unFocusButton(sender)
        saveMarkedMood()
    }
    
    @objc func exit(sender:UIButton) {
        unFocusButton(sender)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func info(sender:UIButton) {
        unFocusButton(sender)
        saveMarkedMood()
    }
    
    @objc func buttonActive(sender:UIButton) {
        focusButton(sender)
    }
    
    @objc func buttonCancelled(sender:UIButton) {
        unFocusButton(sender)
    }
    
    private func focusButton(_ button: UIButton) {
        let duration = 0.6

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            button.layer.shadowRadius = button.layer.shadowRadius + 1.0
            button.layer.shadowOpacity = button.layer.shadowOpacity - 0.2
            button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width + 0.5, height: button.layer.shadowOffset.height + 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha = button.alpha + 0.2
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    private func unFocusButton(_ button: UIButton) {
        let duration = 0.4

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            button.layer.shadowRadius = button.layer.shadowRadius - 1.0
            button.layer.shadowOpacity = button.layer.shadowOpacity + 0.2
            button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width - 0.5, height: button.layer.shadowOffset.height - 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha = button.alpha - 0.2
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
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
        emotion = EmotionManager.getEmotion(
            withValence: userRatings.valence,
            withArousal: userRatings.arousal
        )
        
        updateLabelsRelativeToPosition(tapPosition: (location.x, location.y))
        updateBackground(xScale: (location.x / view.frame.width), yScale: (location.y / view.frame.height))
        
        /// - Update tap to confirm and circle positions
        // TODO: Width Bug
        let verticalBuffer: CGFloat = markSpotlight.frame.height
        let horizontalBuffer: CGFloat = markSpotlight.frame.width + 60
        
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
        
        if (tapToConfirm.frame.origin.y + 30) > self.view.frame.height {
            tapToConfirm.frame.origin.y = location.y - verticalBuffer
        }
    }
    
    
    // When the user starts a tap
    func addMark() {
        
        /// Remove All Overlays
        self.tapToConfirm.alpha = 0
        self.tapToConfirm.layer.shadowRadius = 0.0
        self.tapToConfirm.layer.shadowOpacity = 0.0
        self.tapToConfirm.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.tapToConfirm.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let duration = 0.3
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: [.curveEaseIn],
                       animations: {
                            self.exitButton.alpha = 0.0
                            self.exitButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        
                            self.infoButton.alpha = 0.0
                            self.infoButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        })
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            self.exitButton.layer.shadowRadius = 0.0
            self.exitButton.layer.shadowOpacity = 0.0
            self.exitButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
            self.infoButton.layer.shadowRadius = 0.0
            self.infoButton.layer.shadowOpacity = 0.0
            self.infoButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        CATransaction.commit()
        
        
        /// Shrink the spotlight and stop pusling animation
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
//            self.markSpotlight.transform = CATransform3DMakeScale(0.75, 0.75, 0.75)
//        CATransaction.commit()
        markSpotlight.removeAllAnimations()
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
        self.tapToConfirm.frame.origin.y = tapToConfirm.frame.origin.y + 50
        let buttonDuration = 1.0
        UIView.animate(withDuration: buttonDuration,
                       delay: 0.05,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 10,
                       options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction, .allowAnimatedContent],
                       animations: {
                            self.tapToConfirm.alpha = 0.8
                            self.tapToConfirm.frame.origin.y = self.tapToConfirm.frame.origin.y - 50
                            self.tapToConfirm.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(buttonDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            self.tapToConfirm.layer.shadowRadius = 4.0
            self.tapToConfirm.layer.shadowOpacity = 0.35
            self.tapToConfirm.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        CATransaction.commit()
        
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
        
        /// Readd the spotlight and pulse animation
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1)
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
//            self.markSpotlight.transform = CATransform3DMakeScale(1.33, 1.33, 1.33)
//        CATransaction.commit()
        markSpotlight.add(pulseAnimation, forKey: nil)
        
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
        self.dataCollectionDelegate?.setData(
            ["arousalRating" :userRatings.arousal,
             "valenceRating" :userRatings.valence,
             "emotion"       :emotion]
        )
        
        /// Animate the delegates background
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
        moodLoggingDelegate?.background.startPoint = CGPoint(x: (moodLoggingDelegate?.background.startPoint.x)!, y: 0)
        CATransaction.commit()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
        moodLoggingDelegate?.background.colors =
            [primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor,
             primaryBackgroundColour.cgColor]
        CATransaction.commit()
        
        /// Remove the tap to confirm button
        self.tapToConfirm.removeFromSuperview()
        
        /// Enable forward navigation and gestureSwiping again
        self.screenSlider?.forwardNavigationEnabled = true
        self.screenSlider?.gestureSwipingEnabled = true
        
        /// Informt he delegate to attempt to proceed
        self.screenSlider?.nextScreen()
    }
    
    func calculateMoodFromScreenPosition(x: CGFloat, y: CGFloat) -> (valence: Double, arousal: Double) {
        let arousalCoordinates = -convertCoordinateToRating(coordinate: y, range: self.view.frame.height)
        let valenceCoordinates = convertCoordinateToRating(coordinate: x, range: self.view.frame.width)
        let arousal:Double = Double(arousalCoordinates)
        let valence:Double = Double(valenceCoordinates)
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
        
        primaryBackgroundColour  = UIColor(red: red,      green: green,      blue: blue,      alpha: alpha      )         /// Base (center)
        let topLeft              = UIColor(red: red,      green: green-diff, blue: blue-diff, alpha: alpha      ).cgColor /// +Arousal, -Valence (TOP Left) (blue)
        let topRight             = UIColor(red: red-diff, green: green,      blue: blue-diff, alpha: alpha      ).cgColor /// +Arousal, +Valence (Top RIGHT) (green)
        let bottomRight          = UIColor(red: red-diff, green: green,      blue: blue,      alpha: alpha-diff ).cgColor /// -Arousal, +Valence (BOTTOM Right) (alpha)
        let bottomLeft           = UIColor(red: red,      green: green-diff, blue: blue,      alpha: alpha-diff ).cgColor /// -Arousal, -Valence (Bottom LEFT) (red)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut))
            // view.backgroundColor = colour
            markSpotlight.colors = [primaryBackgroundColour.withAlphaComponent(0.9).cgColor,
                                    primaryBackgroundColour.withAlphaComponent(0.5).cgColor,
                                    primaryBackgroundColour.withAlphaComponent(0).cgColor]
            moodLoggingDelegate?.background.colors = [topLeft, topRight, bottomRight, bottomLeft, topLeft]
            moodLoggingDelegate?.background.startPoint = CGPoint(x: xScale, y: yScale)
        CATransaction.commit()

    }
    
    func addEmotionLabels() {
        for emotion in EmotionManager.allEmotions {
            
            /// - Create and style the label
            let label = CATextLayer()
            label.font = CGFont(UIFont.systemFont(ofSize: 0, weight: UIFont.Weight.ultraLight).fontName as CFString)
            label.opacity = 0
            label.fontSize = 0.0
            label.shadowRadius = 0
            label.shadowOpacity = 0
            label.contentsScale = UIScreen.main.scale
            label.alignmentMode = .center
            label.frame.size = CGSize(width: 200, height: 20)
            label.foregroundColor = UIColor.app.text.solidText().cgColor
            label.shadowOffset = CGSize(width: 0, height: 0)
            label.allowsFontSubpixelQuantization = false
            
            /// - Add the emotion name
            label.string = emotion.adj
            
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
            view.layer.addSublayer(label)
            emotionLabelCollection.append(label)
        }
    }
    
    func updateLabelsRelativeToPosition(tapPosition tap:(x: CGFloat, y: CGFloat)) {
        
        for emotionLabel in emotionLabelCollection {
            
            let largestScreenDistance = (view.frame.size.width / 2) + (view.frame.size.height / 2)
            
            /// - Calculate the frame radius now (axis size divide by 2), to help keep the code clean later on.
            let radius: (width:CGFloat,height:CGFloat) = (
                    width: emotionLabel.frame.width / 2,
                    height: emotionLabel.frame.height / 2
            )
            
            /// - Calculate the position of the center of the label
            let position: (x:CGFloat,y:CGFloat) = (
                x: emotionLabel.frame.origin.x + radius.width,
                y: emotionLabel.frame.origin.y + radius.height
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
                emotionLabel.opacity = Float(0.7 * multiplier)                                              /// Fade the label in as the tap gets closer, up to 0.9 opacity
                emotionLabel.fontSize = (14 * multiplier)                                                   /// Make the label larger as the tap gets closer, up to size 12
                emotionLabel.shadowRadius = CGFloat(3.0 * multiplier)                                       /// Animate shadow
                emotionLabel.shadowOpacity = Float(0.8 * multiplier)                                        /// Animate opacity
                emotionLabel.shadowOffset = CGSize(width: 0, height: CGFloat(6.0 * multiplier).rounded())   /// Animate offset to give layer depth
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

        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    
}
