import UIKit
import SnapKit

class MoodPickerViewController: UIViewController {
    
    lazy var emotionPickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.app.text.solidText()
        label.text = "How are you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emotionPickerLabel)
        detailedView()
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
        emotionPickerLabel.removeFromSuperview()
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
    
    func detailedView() {
        self.view.addSubview(arousalLabel)
        self.view.addSubview(valenceLabel)
        
        arousalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(-35)
            make.centerY.equalToSuperview()
        }
        valenceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - View Building
