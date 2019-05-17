import Firebase

struct TagRecord {

    var uid: String
    var tagRef: DocumentReference
    var tag: Tag
    var quantity: Int
    
    // MARK: - Convenience Iniitialiser
    init(_ tag: Tag, uid: String, tagRef: DocumentReference, quantity: Int) {
        self.uid = uid
        self.tagRef = tagRef
        self.tag = tag
        self.quantity = quantity
    }
}
