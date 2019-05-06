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
    
    var arousalRating: Double?
    var valenceRating: Double?
    var emotion: Mood.Emotion?
    
}


// MARK: - Override Methods
extension MoodLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        circle.addGestureRecognizer(tapGesture)
        screenSlider?.forwardNavigationEnabled = false
        
        screenSlider?.forwardNavigationEnabled = true
        screenSlider?.gestureSwipingEnabled = true
        super.navigationController?.isNavigationBarHidden = false
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
        let moodRatings = calculateMood(x: location.x, y: location.y)
        valenceRating = moodRatings["Valence"]
        arousalRating = moodRatings["Arousal"]
        emotion = EmotionManager.getEmotion(withValence: moodRatings["Valence"]!, withArousal: moodRatings["Arousal"]!)
        emotionPickerLabel.text = emotion?.adj
        emotionPickerLabel.frame.origin.x = location.x - 50
        emotionPickerLabel.frame.origin.y = location.y - 100
        tapToConfirm.frame.origin.x = location.x - 50
        tapToConfirm.frame.origin.y = location.y + 20
        circle.frame.origin.x = location.x - 25
        circle.frame.origin.y = location.y - 25
        
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
        self.dataCollectionDelegate?.setData([
            "arousalRating":arousalRating,
            "valenceRating":valenceRating,
            "emotion":emotion]
        )
        tapToConfirm.removeFromSuperview()
        screenSlider?.forwardNavigationEnabled = true
        screenSlider?.gestureSwipingEnabled = true
        screenSlider?.nextScreen()
    }
    
    func calculateMood(x: CGFloat, y: CGFloat) -> Dictionary<String, Double> {
        let arousalCoordinates = -convertCoordinateToRating(coordinate: y, range: self.view.frame.height)
        let valenceCoordinates = convertCoordinateToRating(coordinate: x, range: self.view.frame.width)
        let arousal:Double = Double(arousalCoordinates)
        let valence:Double = Double(valenceCoordinates)
        let mood = ["Valence":valence,"Arousal":arousal]
        return mood
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
        
        print(red, green, blue, alpha)
        
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)

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
