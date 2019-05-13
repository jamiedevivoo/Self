import Firebase

class MoodManager {
    // Dependencies
    let userMoodLogsReference: CollectionReference
    private var userLogsObserver: ListenerRegistration?

    init(account: Account) {
        userMoodLogsReference = Firestore.firestore().collection("user").document(account.uid).collection("mood_logs")
    }
    deinit {
        userLogsObserver?.remove()
    }
}

// Set MoodLogs
extension MoodManager {
    func updateMood(_ moodLog: Mood.Log) -> Mood.Log {
        var moodLog = moodLog

        /// Check if the Log already has a UID (If it was created from a Brief then it won't, so create one)
        if moodLog.uid == nil {
            moodLog.uid = userMoodLogsReference.document().documentID
        }
        
        userMoodLogsReference.document(moodLog.uid!).setData(moodLog.dictionary, merge: true) { error in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
        }
        
        /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
        return moodLog
    }
}

// Get All Mood Logs
extension MoodManager {
    func getAllMoodlogs(completion: @escaping ([Mood.Log]?) -> Void) {
        userLogsObserver = userMoodLogsReference.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Moods: \(error!.localizedDescription)")
                return
            }
            
            var moods: [Mood.Log] = []
            for document in querySnapshot.documents {
                var moodData = document.data()
                moodData["uid"] = document.documentID
                moodData["timestamp"] = (moodData["timestamp"] as! Timestamp).dateValue()
                let mood = Mood.Log(moodData)
                moods.append(mood)
            }
            
            completion(moods)
        }
    }
    
    func getLatestMoodlog(completion: @escaping ([Mood.Log]?) -> Void) {
        userMoodLogsReference.getDocuments { querySnapshot, error in
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
