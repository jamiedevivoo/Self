import Firebase

class Message {
    
    let userRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid)
    
    var user: User?
    
    var greeting: String?
    var message: String?
    var actions: [UIButton]?
    
    init() {
        create()
    }
    
    func create() {
        self.greeting = createGreeting()
        self.message = "Did you know Mondays are your happiest days? Let’s rock today!"
        self.actions = [UIButton()]
    }
    
    func createGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 00...03:
            return "zzz"
        case 04...06:
            return "Early Morning"
        case 07...10:
            return "Good Morning"
        case 10...12:
            return "It's Lunchtime"
        case 12...17:
            return "Good Afternoon"
        case 17...22:
            return "Good Evening"
        case 22...24:
            return "Good Night"
        default:
            return "Welcome"
        }
    }
}
