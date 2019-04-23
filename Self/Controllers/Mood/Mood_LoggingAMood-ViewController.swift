import UIKit
import SnapKit


final class MoodLoggingAMoodViewController: ViewController {

    var dataCollectionDelegate: DataCollectionSequenceDelegate?
    var screenSlider: ScreenSliderViewController?
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
        return label
    }()
    
    lazy var arousalLabel: UILabel = {
        let label = UILabel.title
        label.text = "< Arousal >"
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
    lazy var valenceLabel: UILabel = {
        let label = UILabel.title
        label.text = "< Valence >"
        label.textColor = UIColor.app.text.solidText()
        return label
    }()
    
}


// MARK: - Override Methods
extension MoodLoggingAMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        screenSlider?.gestureSwipingEnabled = false
    }
    
}


// MARK: - Class Methods
extension MoodLoggingAMoodViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = EmotionManager.getEmotion(withValence: moodRatings["Valence"]!, withArousal: moodRatings["Arousal"]!)
        emotionPickerLabel.text = emotion.adj
        emotionPickerLabel.frame.origin.x = location.x
        emotionPickerLabel.frame.origin.y = location.y - 50
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let _ = EmotionManager.getEmotion(withValence: moodRatings["Valence"]!, withArousal: moodRatings["Arousal"]!)
        screenSlider?.nextScreen()
        screenSlider?.gestureSwipingEnabled = true
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
extension MoodLoggingAMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        view.addSubview(emotionPickerLabel)
        self.view.addSubview(arousalLabel)
        self.view.addSubview(valenceLabel)
        
        emotionPickerLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        arousalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(-25)
            make.centerY.equalToSuperview()
        }
        valenceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
}
