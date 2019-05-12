import Firebase

class SentimentManager {
    // Dependencies
    let userSentimentLogsReference: CollectionReference
    
    init(account: Account) {
        userSentimentLogsReference = Firestore.firestore().collection("user").document(account.uid).collection("mood_logs")
    }
}

// Set MoodLogs
extension SentimentManager {
    func addSentiment(_ sentimentLog: Sentiment.Log) -> Sentiment.Log {
        var sentimentLog = sentimentLog
        
        /// Check if the Log already has a UID (If it was created from a Brief then it won't, so create one)
        if sentimentLog.uid == nil {
            sentimentLog.uid = userSentimentLogsReference.document().documentID
        }
        
        userSentimentLogsReference.document(sentimentLog.uid!).setData(sentimentLog.dictionary, merge: true) { error in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
        }
        /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
        return sentimentLog
    }
}

// Get All Mood Logs
extension SentimentManager {
    func getAllMoodlogs(completion: @escaping ([Mood.Log]?) -> Void) {
        userSentimentLogsReference.getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Moods: \(error!.localizedDescription)")
                return
            }
            
            var moods: [Mood.Log] = []
            for document in querySnapshot.documents {
                let mood = Mood.Log(document.data())
                moods.append(mood)
            }
            
            completion(moods)
        }
    }
    
}
