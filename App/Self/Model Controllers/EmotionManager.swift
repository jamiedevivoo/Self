import Firebase

class EmotionManager {
    
    private let emotionsDBRef: CollectionReference = Firestore.firestore().collection("emotions")
    private var emotionsObserver: ListenerRegistration?
    
    var allEmotions: [Mood.Emotion] = []

    init() {
        emotions { allEmotions in
            self.allEmotions = allEmotions
        }
    }
    
    deinit {
        emotionsObserver?.remove()
    }
}

extension EmotionManager {
    func emotions(completion: @escaping ([Mood.Emotion]) -> Void) {
        emotionsObserver = emotionsDBRef.addSnapshotListener { emotionCollection, error in
            guard let emotionCollection = emotionCollection, error == nil else {
                if let error = error { print("Error Loading Emotions: \(error.localizedDescription)") }
                return
            }
            var allEmotions: [Mood.Emotion] = []
            for emotionDocument in emotionCollection.documents {
                let emotion = Mood.Emotion(emotionDocument.data())
                allEmotions.append(emotion)
            }
            completion(allEmotions)
        }
    }
}

extension EmotionManager {
    func getEmotion(withValence userValence: Double, withArousal userArousal: Double, completion: @escaping (Mood.Emotion) -> Void) {
        emotions { emotions in
            var emotionAndIntensity = [Mood.Emotion: Double]()
            for emotion in emotions {
                let valenceDifference = abs(emotion.valence - userValence)
                let arousalDifference = abs(emotion.arousal - userArousal)
                let sum = valenceDifference + arousalDifference
                emotionAndIntensity[emotion] = sum
            }
            let closestEmotion = emotionAndIntensity.min { a, b in a.value < b.value }
            completion(closestEmotion!.key)
        }
    }
}
