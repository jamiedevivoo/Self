import Firebase

class EmotionManager {
    
    static var allEmotions: [Mood.Emotion] = [
        Mood.Emotion.init(name: "Anger", adj: "angry", valence: -0.8, arousal: 0.8),
        Mood.Emotion.init(name: "Boredom", adj: "bored", valence: 0.4, arousal: -0.8),
        Mood.Emotion.init(name: "Excitement", adj: "excited", valence: 0.8, arousal: 0.8),
        Mood.Emotion.init(name: "Depression", adj: " ", valence: -0.8, arousal: -0.8),
        Mood.Emotion.init(name: "Okay", adj: "okay", valence: 0, arousal: 0)
    ]
    static let emotionsDBRef: CollectionReference = Firestore.firestore().collection("emotions")
    
    static func getAllEmotions(completion: @escaping () -> ()) {
        emotionsDBRef.getDocuments() { emotionCollection, error in
            guard let emotionCollection = emotionCollection, error == nil else {
                if let error = error { print("Error Loading Emotions: \(error.localizedDescription)") }
                return
            }
            print(emotionCollection)
            for emotionDocument in emotionCollection.documents {
                let emotion = Mood.Emotion(emotionDocument.data())
                self.allEmotions.append(emotion)
            }
            completion()
        }
    }
        
    static func getEmotion(withValence userValence: Double, withArousal userArousal: Double) -> Mood.Emotion {
        var emotionAndIntensity = [Mood.Emotion:Double]()
        for emotion in allEmotions {
            let valenceDifference = abs(emotion.valence - userValence)
            let arousalDifference = abs(emotion.arousal - userArousal)
            let sum = valenceDifference + arousalDifference
            emotionAndIntensity[emotion] = sum
        }
        let closestEmotion = emotionAndIntensity.min { a, b in a.value < b.value }
        return closestEmotion!.key
    }
}
