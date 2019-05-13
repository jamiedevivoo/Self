import Firebase

class TagManager {
    // Dependencies
    let userTagsReference: CollectionReference
    private var userTagsObserver: ListenerRegistration?
    
    init(account: Account) {
        userTagsReference = Firestore.firestore().collection("user").document(account.uid).collection("tags")
    }
    deinit {
        userTagsObserver?.remove()
    }
}

// Set MoodLogs
extension TagManager {
    func updateTag(_ tags: [Tag]) -> [Tag] {
        
        var updatedTags = [Tag]()
        
        for tag in tags {
            var tag = tag
            
            /// Check if the Log already has a UID (If it was created from a Brief then it won't, so create one)
            if tag.uid == nil || tag.uid!.count < 1 {
                tag.uid = userTagsReference.document().documentID
            }
            
            if tag.tagRef == nil {
                tag.tagRef = userTagsReference.document(tag.uid!)
            }
            
            print(tag as AnyObject)
            
            userTagsReference.document(tag.uid!).setData(tag.dictionary, merge: true) { error in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    return
                }
            }
            
            updatedTags.append(tag)
        }
        /// Mathod returns new version of log (with updated UID and and/or completeTimestamp from the new dictionary)
        print(updatedTags as AnyObject)
        return updatedTags
    }
}

// Get All Mood Logs
extension TagManager {
    func getAllTags(completion: @escaping ([Tag]?) -> Void) {
        userTagsObserver = userTagsReference.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error Loading Tags: \(error!.localizedDescription)")
                return
            }
            
            var tags: [Tag] = []
            for document in querySnapshot.documents {
                var tagData = document.data()
                tagData["uid"] = document.documentID
                tagData["tag_ref"] = document.reference
                let tag = Tag(tagData)
                tags.append(tag)
            }
            
            completion(tags)
        }
    }
}
