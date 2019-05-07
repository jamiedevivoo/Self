import UIKit
import SnapKit


final class MoodLoggingMoodViewController: ViewController {

    weak var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var moodLoggingDelegate: MoodLoggingDelegate?
    weak var screenSlider: ScreenSliderViewController?
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.layer.frame.size = CGSize(width: 100, height: 50)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tapToConfirm: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "Tap to confirm"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.layer.frame.size = CGSize(width: 100, height: 50)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var arousalLabel: UILabel = {
        let label = UILabel.title
        label.text = "< Mild to Intense >"
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var valenceLabel: UILabel = {
        let label = UILabel.title
        label.text = "< Negative to Positive >"
        label.textColor = UIColor.app.text.solidText()
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
        
        /// - Update the labels
        emotionPickerLabel.text = emotion?.adj
        emotionPickerLabel.frame.origin.x = location.x - 50
        emotionPickerLabel.frame.origin.y = location.y - 100
        
        /// - Update tap to confirm and circle positions
        tapToConfirm.frame.origin.x = location.x - 50
        tapToConfirm.frame.origin.y = location.y + 20
        circle.frame.origin.x = location.x - (circle.frame.width / 2)
        circle.frame.origin.y = location.y - (circle.frame.height / 2)
        
        updateLabelsRelativeToPosition(tapPosition: (location.x, location.y))
        updateBackground(xScale: (location.x / view.frame.width), yScale: (location.y / view.frame.height))
    }
    
    func addMark() {
        view.addSubview(emotionPickerLabel)
        view.addSubview(circle)
        tapToConfirm.removeFromSuperview()
    }
    
    func setMark() {
        emotionPickerLabel.removeFromSuperview()
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
        let red     = 0.9 - (0.8 * xScale)   // 0.9 - 0.1
        let green   = 0.1 + (0.8 * xScale)   // 0.1 - 0.9
        let blue    = 0.1 + (0.8 * yScale)   // 0.1 - 0.9
        let alpha   = 0.6 - (0.2 * yScale)   // 0.6 - 0.4
        
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)

    }
    
    func addEmotionLabels() {
        for emotion in EmotionManager.allEmotions {
            let valenceMultiplier = emotion.valence + 1
            let arousalMultiplier = emotion.arousal + 1
            
            /// - Create and style the label
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.ultraLight)
            label.textAlignment = .center
            label.layer.frame.size = CGSize(width: 80, height: 20)
            
            /// - Add the emotion name
            label.text = emotion.name
            
            /// - Position the label
            let left: CGFloat = CGFloat(self.view.frame.width / 2) - (label.frame.width / 2)    /// First: Get the center horizontal position of the view and label
            label.frame.origin.x = left*CGFloat(valenceMultiplier)                              /// Second: Adjust that position by the multiplier
            let top: CGFloat = CGFloat(self.view.frame.height / 2) - (label.frame.height / 2)   /// First: Get the center vertical position of the view and label
            label.frame.origin.y = top*CGFloat(arousalMultiplier)                               /// Second: Adjust that position by the multiplier
            
            /// - Add the label
            view.addSubview(label)
            emotionLabelCollection.append(label)
        }
    }
    
    func updateLabelsRelativeToPosition(tapPosition tap:(x: CGFloat, y: CGFloat)) {
        
        for emotionLabel in emotionLabelCollection {
            
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
            
            let fractionDistanceFromTap = distanceFromTap.total / 2
            
//            let xDistanceFraction     = xDistanceFromEmotion / (self.view.frame.width / 2)      /// Second: Convert it into a fraction between 0 (very close) and 1 (very far)
//            let yDistanceFromEmotion  = abs(anchorPositon.y - y)                           /// First: Calculate the absolute distance from the labels vertical Anchor
//            let yDistanceFraction     = yDistanceFromEmotion / (self.view.frame.height / 2)     /// Second: Convert it into a fraction between 0 (very close) and 1 (very far)
//            let distanceFraction      = (xDistanceFraction + yDistanceFraction) / 2             /// Then: Combine them to have an overall fraction representing distance
//
//            /// - Create a Multiplier
            var multiplier = fractionDistanceFromTap       /// First: Reverse the distanceFraction so that 0 now represents the furthest distance possible and 1 represents the closest
            multiplier     = 1 - (multiplier / 3)  /// Second:
            
            
//            multiplier     = multiplier +
            
            emotionLabel.alpha          = multiplier
        }
        
    }
    
}


// MARK: - View Building
extension MoodLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(arousalLabel)
        self.view.addSubview(valenceLabel)
        
        arousalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(-50)
            make.centerY.equalToSuperview()
        }
        valenceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
}
