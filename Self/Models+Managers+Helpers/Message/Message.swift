struct Message {
    var messageType: MessageType
    var greeting: String
    var name: String
    var messageText: String
    var actions: [MessageResponse]
    
    enum MessageType {
        case time, insight, mood, urgent, other
    }
}
