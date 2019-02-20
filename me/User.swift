class User {
    
    var name: String
    var lastname: String
    let uid: String
    let email: String
    
    init?(uid:String, name:String,lastname:String,email:String) {
        self.uid = uid
        
        self.name = name
        self.lastname = lastname
        self.email = email
    }
    
}
