import Firebase

class EmotionManager {
    
    static var allEmotions: [Mood.Emotion] = [
        Mood.Emotion.init(name: "Anger", adj: "angry", valence: -0.8, arousal: 0.8),
        Mood.Emotion.init(name: "Anger", adj: "A bit angry", valence: -0.6, arousal: 0.4),
        Mood.Emotion.init(name: "Boredom", adj: "bored", valence: 0.4, arousal: -0.8),
        Mood.Emotion.init(name: "Boredom", adj: "A bit bored", valence: 0.6, arousal: -0.4),
        Mood.Emotion.init(name: "Excitement", adj: "excited", valence: 0.8, arousal: 0.8),
        Mood.Emotion.init(name: "Excitement", adj: "Almost excited", valence: 0.6, arousal: 0.4),
        Mood.Emotion.init(name: "Depression", adj: "Depressed", valence: -0.8, arousal: -0.8),
        Mood.Emotion.init(name: "Nearly Depression", adj: "Nearly depressed", valence: -0.6, arousal: -0.4),
        Mood.Emotion.init(name: "Okay", adj: "okay", valence: 0, arousal: 0)
    ]
    let emotionsDBRef: CollectionReference = Firestore.firestore().collection("emotions")
    
    func getAllEmotions(completion: @escaping ([Mood.Emotion]) -> ()) {
        emotionsDBRef.getDocuments() { emotionCollection, error in
            guard let emotionCollection = emotionCollection, error == nil else {
                if let error = error { print("Error Loading Emotions: \(error.localizedDescription)") }
                return
            }
            print(emotionCollection)
            var allEmotions: [Mood.Emotion] = []
            for emotionDocument in emotionCollection.documents {
                let emotion = Mood.Emotion(emotionDocument.data())
                allEmotions.append(emotion)
            }
            completion(allEmotions)
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
