import UIKit
import SnapKit

struct Emotion: Hashable {
    var name: String
    var adj: String
    var valence: CGFloat
    var arousal: CGFloat
}

class AddMoodViewController: UIViewController {
    
    let emotions = [
    Emotion.init(name: "Anger", adj: "angry", valence: 1, arousal: -1),
    Emotion.init(name: "Boredom", adj: "bord", valence: 0.5, arousal: -1),
    Emotion.init(name: "Excitement", adj: "excited", valence: 1, arousal: 1),
    Emotion.init(name: "Okay", adj: "okay", valence: 0, arousal: 0)
    ]
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emotionLabel)
        
        emotionLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emotionLabel.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = getClosestEmotion(moodRatings: moodRatings, emotions: emotions)
        emotionLabel.text = emotion?.adj
        emotionLabel.frame.origin.x = location.x
        emotionLabel.frame.origin.y = location.y - 50
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let moodRatings = calculateMood(x: location.x, y: location.y)
        let emotion = getClosestEmotion(moodRatings: moodRatings, emotions: emotions)
    }
    
    func calculateMood(x: CGFloat, y: CGFloat) -> Dictionary<String, CGFloat> {
        let arousal = -convertCoordinateToRating(coordinate: y, range: self.view.frame.height)
        let valence = convertCoordinateToRating(coordinate: x, range: self.view.frame.width)
        let mood = ["Valence":valence,"Arousal":arousal]
        return mood
    }
    
    func convertCoordinateToRating(coordinate: CGFloat, range: CGFloat) -> CGFloat {
        let scale = range / 2
        let rating = (coordinate - scale) / scale
        let ratingRounded = CGFloat(round(100*rating)/100)
        return ratingRounded
    }
    
    func getClosestEmotion(moodRatings: Dictionary<String, CGFloat>, emotions: [Emotion]) -> Emotion? {
        var emotionIntensity = [Emotion:CGFloat]()
        
        for emotion in emotions {
            let valenceDifference = abs(moodRatings["Valence"]! - emotion.valence)
            let arousalDifference = abs(moodRatings["Arousal"]! - emotion.arousal)
            let sum = valenceDifference + arousalDifference
            emotionIntensity[emotion] = sum
        }
        let closestEmotion = emotionIntensity.min { a, b in a.value < b.value }
        return closestEmotion!.key
    }

}
