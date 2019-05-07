import UIKit
import SnapKit


final class MoodLoggingMoodViewController: ViewController {

    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    weak var screenSlider: ScreenSliderViewController?
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.view.layer.frame
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x:0, y:0)
        layer.type = .conic
        layer.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.clear.cgColor]
        return layer
    }()
    
    lazy var tapToConfirm: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "Tap to confirm"
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
        label.layer.frame.size = CGSize(width: 200, height: 50)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var circle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.secondaryBackground()
        view.layer.frame.size = CGSize(width: 50, height: 50)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tappedCircle))
        return gesture
    }()
    
    var isMoodMarked:Bool = false
    var markAdded: Bool = false
    
    var userRatings: (valence: Double, arousal: Double) = (0,0)
    var emotion: Mood.Emotion?
    
    var emotionLabelCollection: [UILabel] = []
    
}


// MARK: - Override Methods
extension MoodLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        circle.addGestureRecognizer(tapGesture)
        screenSlider?.forwardNavigationEnabled = false
        super.navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        view.layer.addSublayer(gradientLayer)
        addEmotionLabels()
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
        updateMark(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateMark(touch: touch)
        setMark()
    }
    
    @objc func tappedCircle() {
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
        tapToConfirm.frame.origin.x = location.x - 50
        tapToConfirm.frame.origin.y = location.y + 20
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        circle.frame.origin.x = location.x - (circle.frame.width / 2)
        circle.frame.origin.y = location.y - (circle.frame.height / 2)
        CATransaction.commit()
        
        updateLabelsRelativeToPosition(tapPosition: (location.x, location.y))
        updateBackground(xScale: (location.x / view.frame.width), yScale: (location.y / view.frame.height))
    }
    
    func addMark() {
        view.addSubview(circle)
        tapToConfirm.removeFromSuperview()
    }
    
    func setMark() {
        view.addSubview(tapToConfirm)
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
        tapToConfirm.removeFromSuperview()
        screenSlider?.forwardNavigationEnabled = true
        screenSlider?.gestureSwipingEnabled = true
        screenSlider?.nextScreen()
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
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
            gradientLayer.startPoint = CGPoint(x: xScale, y: yScale)
        CATransaction.commit()

        /// - Calculate each of the colour attributes. Format: initialValue Operator (mutableRange * mutator)
        let red     = 0.9 - (0.8 * xScale)   /// 0.9 - 0.1
        let green   = 0.1 + (0.8 * xScale)   /// 0.1 - 0.9
        let blue    = 0.1 + (0.8 * yScale)   /// 0.1 - 0.9
        let alpha   = 0.6 - (0.2 * yScale)   /// 0.6 - 0.4
        
//        let colour      = UIColor(red: red,     green: green,     blue: blue,     alpha: alpha    )         /// Base (center)
        let topLeft     = UIColor(red: red, green: green-0.1,     blue: blue-0.03,     alpha: alpha).cgColor /// More Arousal (TOP Left) (blue)
        let topRight    = UIColor(red: red-0.1,     green: green, blue: blue-0.03,     alpha: alpha).cgColor /// More Valance (Top RIGHT) (green)
        let bottomRight = UIColor(red: red-0.1,     green: green, blue: blue, alpha: alpha-0.1    ).cgColor /// Less Arousal (BOTTOM Right) (alpha)
        let bottomLeft  = UIColor(red: red, green: green-0.1,     blue: blue, alpha: alpha-0.1    ).cgColor /// Less Valence (Top LEFT) (red)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
//            view.backgroundColor = colour
            gradientLayer.colors = [topLeft, topRight, bottomRight, bottomLeft, topLeft]
        CATransaction.commit()

    }
    
    func addEmotionLabels() {
        for emotion in EmotionManager.allEmotions {
            
            /// - Create and style the label
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.ultraLight)
            label.textAlignment = .center
            label.layer.frame.size = CGSize(width: 200, height: 20)
            label.textColor = UIColor.app.text.solidText()
            label.layer.shadowRadius = 4.0
            label.layer.shadowOpacity = 0.6
            label.layer.shadowOffset = CGSize(width: 0, height: 5)
            
            /// - Add the emotion name
            label.text = emotion.adj
            
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
            view.addSubview(label)
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
                y: abs(position.y - tap.y),
                total: abs(position.x - tap.x) + abs(position.y - tap.y)
            )
            
            /// - Create a Multiplier
            let catchmentDistance = largestScreenDistance / 3                       /// The fraction of the screen around the label the tap must be in before multipliers take effect
            let bufferedDistance = distanceFromTap.total - 50                       /// Buffer so that multipliers reach their max value before the users tap covers it
            var multiplier = 1 - (bufferedDistance / catchmentDistance)             /// Fraction representing 1 as the position of the label and 0 as the furthest possible distance || 0.8
            multiplier = (multiplier < 0) ? 0 : ((multiplier > 1) ? 1 : multiplier) /// Restrict the multiplier to between 0 and 1
            
            
            /// - Apply the Multipliers
            emotionLabel.alpha = 0.8 * multiplier                                   /// Fade the label in as the tap gets closer, up to 0.9 opacity
            emotionLabel.font = UIFont.systemFont(ofSize: 12 * multiplier)  /// Make the label larger as the tap gets closer, up to size 12
            emotionLabel.layer.shadowRadius = CGFloat(4.0 * multiplier)
            emotionLabel.layer.shadowOpacity = Float(0.6 * multiplier)
            emotionLabel.layer.shadowOffset = CGSize(width: 0, height: CGFloat(5.0 * multiplier).rounded())

        }
        
    }
    
}


// MARK: - View Building
extension MoodLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
    }
    
}
