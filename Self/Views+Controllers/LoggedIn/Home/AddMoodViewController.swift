import UIKit
import SnapKit

class AddMoodViewController: UIViewController {
    
    let emotions = [
        Emotion.init(name: "Anger", adj: "angry", valence: -0.8, arousal: 0.8),
        Emotion.init(name: "Boredom", adj: "bored", valence: 0.4, arousal: -0.8),
        Emotion.init(name: "Excitement", adj: "excited", valence: 0.8, arousal: 0.8),
        Emotion.init(name: "Depression", adj: " ", valence: -0.8, arousal: -0.8),
        Emotion.init(name: "Okay", adj: "okay", valence: 0, arousal: 0)
    ]
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel()
        label.text = "I am..."
        return label
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a tag..."
        return label
    }()
    
    lazy var describeYourDay: UILabel = {
        let label = UILabel()
        label.text = "Describe your day..."
        return label
    }()
    
    lazy var wildcardQuestion: UILabel = {
        let label = UILabel()
        label.text = "Your Wildcard Question"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emotionPickerLabel)
        
        emotionPickerLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = getClosestEmotion(moodRatings: moodRatings, emotions: emotions)
        emotionPickerLabel.text = emotion?.adj
        emotionPickerLabel.frame.origin.x = location.x
        emotionPickerLabel.frame.origin.y = location.y - 50
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = getClosestEmotion(moodRatings: moodRatings, emotions: emotions)
        
        guard let _ = emotion else { return }
        emotionLabel.text = "I am \(emotion!.adj)"
        
        detailedView()
    }
    
    func calculateMood(x: CGFloat, y: CGFloat) -> Dictionary<String, Double> {
        let arousalCoordinates = -convertCoordinateToRating(coordinate: y, range: self.view.frame.height)
        let valenceCoordinates = convertCoordinateToRating(coordinate: x, range: self.view.frame.width)
        let arousal:ArousalDouble = Double(arousalCoordinates)
        let valence:ArousalDouble = Double(valenceCoordinates)
        let mood = ["Valence":valence,"Arousal":arousal]
        return mood
    }
    
    func convertCoordinateToRating(coordinate: CGFloat, range: CGFloat) -> CGFloat {
        let scale = range / 2
        let rating = (coordinate - scale) / scale
        let ratingRounded = CGFloat(round(100*rating)/100)
        return ratingRounded
    }
    
    func getClosestEmotion(moodRatings: Dictionary<String, Double>, emotions: [Emotion]) -> Emotion? {
        var emotionIntensity = [Emotion:Double]()
        
        for emotion in emotions {
            let valenceDifference = abs(moodRatings["Valence"]! - emotion.valence)
            let arousalDifference = abs(moodRatings["Arousal"]! - emotion.arousal)
            let sum = valenceDifference + arousalDifference
            emotionIntensity[emotion] = sum
        }
        let closestEmotion = emotionIntensity.min { a, b in a.value < b.value }
        return closestEmotion!.key
    }
    
    func detailedView() {
        emotionPickerLabel.removeFromSuperview()
        
        self.view.addSubview(emotionLabel)
        self.view.addSubview(tagLabel)
        self.view.addSubview(describeYourDay)
        self.view.addSubview(wildcardQuestion)
        
        emotionLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        tagLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(emotionLabel)
            make.height.equalTo(50)
        }
        describeYourDay.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagLabel)
            make.height.equalTo(50)
        }
        wildcardQuestion.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(describeYourDay)
            make.height.equalTo(50)
        }
    }

}

// MARK: - View Building
