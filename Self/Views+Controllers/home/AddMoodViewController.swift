import UIKit
import SnapKit

class AddMoodViewController: UIViewController {
    
    let anger = ["Valence":-1,"Arousal":1] as [String:CGFloat]
    let excited = ["Valence":1,"Arousal":1] as [String:CGFloat]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let mood = calculateMood(x: location.x, y: location.y)
        print(mood)
        print(getClosestEmotion(mood: mood, emotions: [anger,excited]))
    }
    
    func calculateMood(x: CGFloat, y: CGFloat) -> Dictionary<String, CGFloat> {
        let arousal = -convertToScale(coordinate: y, scale: self.view.frame.height)
        let valence = convertToScale(coordinate: x, scale: self.view.frame.width)
        let mood = ["Valence":valence,"Arousal":arousal]
        return mood
    }
    
    func convertToScale(coordinate: CGFloat, scale: CGFloat) -> CGFloat {
        let scale = scale / 2
        let position = (coordinate - scale) / scale
        let grade = CGFloat(round(100*position)/100)
        return grade
    }
    
    func getClosestEmotion(mood: Dictionary<String, CGFloat>, emotions: [[String:CGFloat]]) -> [[String:CGFloat]] {
        var emotions = emotions
        for emotion in emotions {
            let valenceDifference = abs(mood["Valence"]! - emotion["Valence"]!)
            let arousalDifference = abs(mood["Arousal"]! - emotion["Arousal"]!)
            let sum = valenceDifference + arousalDifference
            emotion["differenceToUser"] = sum
        }
        
        return emotions.sorted {$0["differenceToUser"]! < $1["differenceToUser"]!}
    }

}
