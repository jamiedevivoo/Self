import Firebase

class Message {
    
    enum MessageType {
        case time
        case insight
        case mood
        case urgent
        case other
    }
    
    let userRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid)
    
    var user: UserInfo?
    
    var greeting: String?
    var messageText: String?
    var actions: [String]?
    
    var type: MessageType = .time
    
    init() {
        create()
    }
    
    func create() {
        self.greeting = createGreeting()
        self.messageText = "Did you know Mondays are your happiest days? Let’s rock today!"
        self.actions = ["💪","😔","🆘"]
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
