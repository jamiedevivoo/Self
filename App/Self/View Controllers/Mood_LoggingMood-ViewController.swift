import UIKit
import SnapKit

//: TODO: This class needs a lot of tidying up
final class MoodLoggingMoodViewController: ViewController {

    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    weak var screenSlider: ScreenSliderViewController?
    
    lazy var tapToConfirm: UIButton = {
        let button = UIButton()
        button.setTitle("Tap to Confirm", for: .normal)
        button.setTitleColor(UIColor.app.button.primary.text(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.frame.size = CGSize(width: 200, height: 50)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.app.button.primary.fill()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
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
        gradient.locations = [0.0, 0.6, 1]
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.backgroundFilters = [CIFilter(name: "CIGaussianBlur",parameters: [kCIInputRadiusKey: 10])!]
        return gradient
    }()
    
    lazy var pulseAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = 1.5
        animation.fromValue = CATransform3DMakeScale(1.0, 1.0, 1.0)
        animation.toValue = CATransform3DMakeScale(0.75, 0.75, 0.8)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tappedCircle))
        gesture.cancelsTouchesInView = true
        return gesture
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
        setupChildViews()
        screenSlider?.forwardNavigationEnabled = false
        super.navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        addEmotionLabels()
        view.layer.addSublayer(markSpotlight)
        view.backgroundColor = .clear
        markSpotlight.add(pulseAnimation, forKey: nil)
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
    
    @objc func tappedCircle() {
        print("tapped")
        saveMarkedMood()
    }
    
    
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
        
        /// - Update tap to confirm and circle positions
        tapToConfirm.frame.origin.x = location.x - (tapToConfirm.frame.width / 2)
        tapToConfirm.frame.origin.y = location.y + (markSpotlight.frame.height / 2) + (tapToConfirm.frame.height / 2)
        
        updateLabelsRelativeToPosition(tapPosition: (location.x, location.y))
        updateBackground(xScale: (location.x / view.frame.width), yScale: (location.y / view.frame.height))
    }
    
    func addMark() {
        tapToConfirm.removeFromSuperview()
    }
    
    func setMark() {
        view.addSubview(tapToConfirm)
        tapToConfirm.addGestureRecognizer(tapGesture)
        guard markAdded == false else { return }
        isMoodMarked = true
        markAdded = true
    }
    
    
    func saveMarkedMood() {
        guard isMoodMarked == true else { return }
        self.dataCollectionDelegate?.setData(
            ["arousalRating" :userRatings.arousal,
             "valenceRating" :userRatings.valence,
             "emotion"       :emotion]
        )
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn))
            print(primaryBackgroundColour.cgColor)
            moodLoggingDelegate?.background.colors =
                [primaryBackgroundColour.cgColor,
                 primaryBackgroundColour.cgColor,
                 primaryBackgroundColour.cgColor,
                 primaryBackgroundColour.cgColor,
                 primaryBackgroundColour.cgColor]
            self.tapToConfirm.removeFromSuperview()
            self.screenSlider?.forwardNavigationEnabled = true
            self.screenSlider?.gestureSwipingEnabled = true
            self.screenSlider?.nextScreen()
        CATransaction.commit()
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
    
    func updateBackground(xScale: CGFloat, yScale: CGFloat) {
        /// xScale is valence
        /// yScale is Arousal
        /// - Calculate each of the colour attributes. Format: initialValue Operator (mutableRange * mutator)
        let red     = 0.9 - (0.8 * xScale)   /// 0.9 - 0.1
        let green   = 0.1 + (0.8 * xScale)   /// 0.1 - 0.9
        let blue    = 0.1 + (0.8 * yScale)   /// 0.1 - 0.9
        let alpha   = 0.6 - (0.2 * yScale)   /// 0.6 - 0.4
        
        primaryBackgroundColour  = UIColor(red: red,      green: green,      blue: blue,      alpha: alpha      )         /// Base (center)
        let topLeft              = UIColor(red: red,      green: green-0.15, blue: blue-0.15, alpha: alpha      ).cgColor /// +Arousal, -Valence (TOP Left) (blue)
        let topRight             = UIColor(red: red-0.15, green: green,      blue: blue-0.15, alpha: alpha      ).cgColor /// +Arousal, +Valence (Top RIGHT) (green)
        let bottomRight          = UIColor(red: red-0.15, green: green,      blue: blue,      alpha: alpha-0.15 ).cgColor /// -Arousal, +Valence (BOTTOM Right) (alpha)
        let bottomLeft           = UIColor(red: red,      green: green-0.15, blue: blue,      alpha: alpha-0.15 ).cgColor /// -Arousal, -Valence (Bottom LEFT) (red)
        
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
                emotionLabel.opacity = Float(0.8 * multiplier)                                              /// Fade the label in as the tap gets closer, up to 0.9 opacity
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
    }
    
}
