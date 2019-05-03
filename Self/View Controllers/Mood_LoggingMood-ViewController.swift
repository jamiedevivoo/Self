import UIKit
import SnapKit


final class MoodLoggingMoodViewController: ViewController {

    var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var screenSlider: ScreenSliderViewController?
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
        label.layer.frame.size = CGSize(width: 50, height: 50)

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
    
}


// MARK: - Override Methods
extension MoodLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        circle.addGestureRecognizer(tapGesture)
        screenSlider?.forwardNavigationEnabled = false
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
        updateMark(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateMark(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateMark(touch: touch)
        addMark()
    }
    
    @objc func tappedCircle() {
        saveMarkedMood()
    }
    
    
    // Other Methods
    func updateMark(touch: UITouch) {
        
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = EmotionManager.getEmotion(withValence: moodRatings["Valence"]!, withArousal: moodRatings["Arousal"]!)
        emotionPickerLabel.text = emotion.adj
        emotionPickerLabel.frame.origin.x = location.x
        emotionPickerLabel.frame.origin.y = location.y - 25

        circle.frame.origin.x = location.x - 25
        circle.frame.origin.y = location.y - 25
    }
    
    func addMark() {
        guard markAdded == false else { return }
        
        isMoodMarked = true
        markAdded = true
        view.addSubview(emotionPickerLabel)
        view.addSubview(circle)
    }
    
    
    func saveMarkedMood() {
        guard isMoodMarked == true else { return }
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
